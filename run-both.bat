@echo off
ECHO Launching Paint.NET and AutoSave Utility...

:: -------------- CONFIGURATION START ----------------

:: 1. SET THE PATH TO YOUR POWERSHELL SCRIPT
SET "PSScriptPath=C:\Path\To\Your\Script\AutoSave-PaintDotNet.ps1"

:: 2. SET THE PATH TO YOUR PAINT.NET EXECUTABLE
SET "PdnExePath=C:\Program Files\Paint.NET\paintdotnet.exe"

:: --------------- CONFIGURATION END ----------------










start "" "%PdnExePath%"
start "Pdn AutoSave Console" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PSScriptPath%"

ECHO.
ECHO Both Paint.NET and the AutoSave utility have been launched.
ECHO Close the Paint.NET application to stop the AutoSave utility's loop.

pause
