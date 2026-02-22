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
    echo Success: Setup.exe created!
) else (
    echo Build failed for Setup.cs
    pause
    exit /b 1
)

echo.
echo Compiling Update.cs...
"%CSC_PATH%" /out:Update.exe Update.cs

if %ERRORLEVEL% equ 0 (
    echo Success: Update.exe created!
) else (
    echo Build failed for Update.cs
    pause
    exit /b 1
)

echo.
echo Compile Complete!
pause
