@echo off
echo Iniciando Medieval City Generator...
cd /d "%~dp0"

echo Directorio actual: %CD%

if not exist "main.js" (
    echo ERROR: main.js no encontrado en %CD%
    pause
    exit /b 1
)

if not exist "node_modules\electron\dist\electron.exe" (
    echo ERROR: Electron no encontrado en %CD%\node_modules\electron\dist\
    pause
    exit /b 1
)

echo Ejecutando: node_modules\electron\dist\electron.exe . --dev
node_modules\electron\dist\electron.exe . --dev

if errorlevel 1 (
    echo ERROR: Falló la ejecución de Electron
    pause
    exit /b 1
)
