Add-Type -AssemblyName System.Windows.Forms
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll", SetLastError = true)]
    public static extern int GetWindowThreadProcessId(IntPtr hWnd, out int lpdwProcessId);

    [DllImport("user32.dll")]
    public static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

    [StructLayout(LayoutKind.Sequential)]
    public struct LASTINPUTINFO {
        public uint cbSize;
        public uint dwTime;
    }
}
'@

# --- USER CONFIGURATION ---
$AppName = "PaintDotNet"
$SaveKey = "^s"  # CORRECTED: '^' represents the Control key (Ctrl+S)
$IdleThresholdSeconds = 30  # Save if user is idle for 30 seconds
$CheckIntervalSeconds = 60   # Check every 1 minute
# --------------------------

Write-Host "Paint.NET AutoSave Utility Started."
Write-Host "Idle threshold: $IdleThresholdSeconds seconds. Check interval: $CheckIntervalSeconds seconds."

while ($true) {
    # 1. Get Foreground Window Process
    $fgWindowHandle = [Win32]::GetForegroundWindow()
    
    # CRITICAL FIX: Initialize $fgProcessId before passing it by reference
    $fgProcessId = 0 
    
    # Get the Process ID (PID). [void] suppresses the output clutter.
    [void][Win32]::GetWindowThreadProcessId($fgWindowHandle, [ref]$fgProcessId)
    
    # Get the process object.
    $fgProcess = Get-Process -Id $fgProcessId -ErrorAction SilentlyContinue

    if ($fgProcess -and $fgProcess.ProcessName -eq $AppName) {
        
        # 2. Check User Idle Time
        $lastInputInfo = New-Object Win32+LASTINPUTINFO
        $lastInputInfo.cbSize = [System.Runtime.InteropServices.Marshal]::SizeOf($lastInputInfo)
        
        # Get the time of the last input event (output is True/False). [void] suppresses the output clutter.
        [void][Win32]::GetLastInputInfo([ref]$lastInputInfo)

        $currentTickCount = [Environment]::TickCount
        $timeSinceLastInputMs = $currentTickCount - $lastInputInfo.dwTime
        
        # Handle TickCount wrap-around 
        if ($timeSinceLastInputMs -lt 0) {
            $timeSinceLastInputMs = [uint32]::MaxValue + $timeSinceLastInputMs 
        }

        $timeSinceLastInputSeconds = $timeSinceLastInputMs / 1000

        if ($timeSinceLastInputSeconds -ge $IdleThresholdSeconds) {
            
            # 3. Trigger Autosave 
            Write-Host "[$([DateTime]::Now.ToString('HH:mm:ss'))] Paint.NET is active and user is idle ($([math]::Round($timeSinceLastInputSeconds))s). Simulating Ctrl+S..."
            
            # Send the CORRECTED Ctrl+S command
            [System.Windows.Forms.SendKeys]::SendWait($SaveKey)
            
            # After a successful save, wait the full interval before checking again
            Start-Sleep -Seconds $CheckIntervalSeconds 
        } else {
            Write-Host "[$([DateTime]::Now.ToString('HH:mm:ss'))] Paint.NET is active but user is NOT idle ($([math]::Round($timeSinceLastInputSeconds))s). Waiting..."
            # If not idle, wait a shorter period to be more responsive to the idle threshold
            Start-Sleep -Seconds 5 
        }
    } else {
        Write-Host "[$([DateTime]::Now.ToString('HH:mm:ss'))] Paint.NET is not the foreground window. Waiting..."
        # Wait the full interval if Paint.NET isn't in focus
        Start-Sleep -Seconds $CheckIntervalSeconds
    }
}