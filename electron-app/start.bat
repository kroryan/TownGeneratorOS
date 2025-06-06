@echo off
echo Iniciando Medieval City Generator...
cd /d "%~dp0"

echo Verificando archivos necesarios...
if not exist "main.js" (
    echo ERROR: main.js no encontrado
    pause
    exit /b 1
)

if not exist "package.json" (
    echo ERROR: package.json no encontrado
    pause
    exit /b 1
)

if not exist "node_modules\electron" (
    echo ERROR: Electron no está instalado. Ejecutando npm install...
    npm install
    if errorlevel 1 (
        echo ERROR: Falló la instalación de dependencias
        pause
        exit /b 1
    )
)

echo Ejecutando aplicación Electron...
node node_modules\electron\cli.js . --dev

if errorlevel 1 (
    echo ERROR: Falló la ejecución de Electron
    pause
    exit /b 1
)
