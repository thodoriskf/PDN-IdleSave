# Paint.NET AutoSave (Idle-triggered)

A lightweight Windows helper that automatically saves your work in **Paint.NET** when you’ve been idle for a configurable number of seconds. It watches the foreground window and, if it’s Paint.NET and you’ve been inactive long enough, it simulates **Ctrl+S**.

## How it works
- Monitors the **foreground window** and **user idle time** via Win32 APIs.
- When the active app is `PaintDotNet` and idle time ≥ threshold, it sends **Ctrl+S** using `SendKeys`.
- Checks again on a timer to avoid spamming saves.

## Files
- **AutoSave-PaintDotNet.ps1** — PowerShell script that does the monitoring and triggers
- **run-autosave.bat** — Simple launcher
- **run-both.bat**- Launches Paintnet and the launcher at the same time( Note: Adjust the path ,it will be show below)

## Setup & Run
### Option 1: 
1. Download `run-autosave.bat` and `AutoSave-PaintDotNet.ps1` 
2. Place both files in the same folder.
3. Double-click `run-autosave.bat` to start the utility.
4. Keep the console window open while working in Paint.NET.

### Option 2:
1. Download `run-both.bat` and  `AutoSave-PaintDotNet.ps1` 
2. Edit the `run-both.bat` and change the path to the powershell script and (if necessary) to the paintnet application executable and save.
3. Launch using `run-both.bat` if you wish to run Paint.NET with autosave.
4. Keep the console window open while working in Paint.NET.
  

> If PowerShell execution is restricted, the batch file already uses `-ExecutionPolicy Bypass`.

## Configuration
Open `AutoSave-PaintDotNet.ps1` and adjust these values near the top:

```powershell
$AppName = "PaintDotNet"           # Process name for Paint.NET
$SaveKey = "^s"                    # Ctrl+S (SendKeys format)
$IdleThresholdSeconds = 30         # Save when idle ≥ 30s
$CheckIntervalSeconds = 60         # Recheck every 60s
