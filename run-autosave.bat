@echo off
ECHO Launching Paint.NET AutoSave Utility...

:: Get the directory where this batch file is located
SET "ScriptDir=%~dp0"

:: Construct the full path to the PowerShell script
SET "ScriptPath=%ScriptDir%AutoSave-PaintDotNet.ps1"

:: Execute the script using the correct path variable
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ScriptPath%"

ECHO.
ECHO AutoSave Utility has stopped.
pause