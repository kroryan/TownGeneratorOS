# Medieval City Generator - Launcher Script
# Script mejorado para iniciar la aplicación Electron

Write-Host "=== Medieval Fantasy City Generator ===" -ForegroundColor Cyan
Write-Host "Iniciando aplicación..." -ForegroundColor Green

# Cambiar al directorio correcto
$electronAppPath = "C:\Users\adryl\Desktop\proy\TownGeneratorOS\electron-app"
Set-Location $electronAppPath

# Verificar archivos necesarios
if (-not (Test-Path "main.js")) {
    Write-Error "ERROR: main.js no encontrado en $electronAppPath"
    Read-Host "Presiona Enter para salir"
    exit 1
}

if (-not (Test-Path "package.json")) {
    Write-Error "ERROR: package.json no encontrado"
    Read-Host "Presiona Enter para salir"
    exit 1
}

if (-not (Test-Path "node_modules\electron\dist\electron.exe")) {
    Write-Host "ERROR: Electron no está instalado. Instalando dependencias..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Error "ERROR: Falló la instalación de dependencias"
        Read-Host "Presiona Enter para salir"
        exit 1
    }
}

# Verificar que el build web existe
if (-not (Test-Path "web-build\index.html")) {
    Write-Host "Build web no encontrado. Construyendo aplicación web..." -ForegroundColor Yellow
    node build-web.js
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Advertencia: El build web falló, pero intentaremos continuar"
    }
}

Write-Host "Iniciando Medieval City Generator..." -ForegroundColor Green
Write-Host "- Aplicación de escritorio se abrirá automáticamente" -ForegroundColor Gray
Write-Host "- Servidor web disponible en: http://localhost:3000" -ForegroundColor Gray
Write-Host "- La aplicación se recargará automáticamente para asegurar el funcionamiento" -ForegroundColor Yellow
Write-Host ""

try {
    # Usar Start-Process con la sintaxis correcta de PowerShell
    Start-Process -FilePath "C:\Users\adryl\Desktop\proy\TownGeneratorOS\electron-app\node_modules\electron\dist\electron.exe" -ArgumentList ".", "--dev" -WorkingDirectory $electronAppPath
    
    Write-Host "✓ Aplicación iniciada correctamente" -ForegroundColor Green
    Write-Host ""
    Write-Host "Nota: La aplicación se recargará automáticamente después de 1 y 3 segundos" -ForegroundColor Cyan
    Write-Host "para asegurar que el generador de ciudades funcione correctamente." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Para cerrar la aplicación, cierra la ventana o presiona Ctrl+C aquí" -ForegroundColor Gray
}
catch {
    Write-Error "ERROR: No se pudo iniciar la aplicación: $_"
    Read-Host "Presiona Enter para salir"
    exit 1
}

# Mantener el script corriendo para mostrar información
Write-Host "Aplicación ejecutándose... Presiona Ctrl+C para salir de este script" -ForegroundColor Green
try {
    while ($true) {
        Start-Sleep -Seconds 5
        # Verificar si el proceso sigue ejecutándose
        $electronProcess = Get-Process | Where-Object {$_.ProcessName -eq "electron" -or $_.MainWindowTitle -like "*Medieval*"}
        if (-not $electronProcess) {
            Write-Host "La aplicación se ha cerrado." -ForegroundColor Yellow
            break
        }
    }
}
catch {
    Write-Host "Script terminado." -ForegroundColor Gray
}
