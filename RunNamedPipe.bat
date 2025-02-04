@echo off
setlocal

REM Path to the PowerShell script
set scriptPath=%~dp0NamedPipe.ps1

REM Start the PowerShell script to read from the pipe in a new window
start powershell -NoExit -ExecutionPolicy Bypass -Command "& '%scriptPath%' -mode read"

REM Wait a moment to ensure the read script is ready
timeout /t 2 /nobreak > nul

REM Start the PowerShell script to write to the pipe in a new window
start powershell -NoExit -ExecutionPolicy Bypass -Command "& '%scriptPath%' -mode write"

endlocal
