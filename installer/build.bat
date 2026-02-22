@echo off
set "CSC_PATH=C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"

if not exist "%CSC_PATH%" (
    echo Error: C# Compiler (csc.exe) not found at %CSC_PATH%
    pause
    exit /b 1
)

echo Compiling Setup.cs...
"%CSC_PATH%" /out:Setup.exe Setup.cs

if %ERRORLEVEL% equ 0 (
    echo.
    echo Success: Setup.exe created!
) else (
    echo.
    echo Build failed.
)

pause
