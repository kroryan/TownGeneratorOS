#!/usr/bin/env pwsh
# Script para ejecutar Electron

Write-Host "Iniciando Medieval City Generator..."

# Cambiar al directorio correcto
Set-Location $PSScriptRoot

# Verificar que los archivos necesarios existen
if (-not (Test-Path "main.js")) {
    Write-Error "main.js no encontrado"
    exit 1
}

if (-not (Test-Path "package.json")) {
    Write-Error "package.json no encontrado"
    exit 1
}

if (-not (Test-Path ".\node_modules\electron")) {
    Write-Error "Electron no está instalado. Ejecuta 'npm install' primero."
    exit 1
}

# Intentar ejecutar Electron
try {
    Write-Host "Ejecutando Electron..."
    & ".\node_modules\.bin\electron.ps1" . --dev
}
catch {
    Write-Host "Error ejecutando electron.ps1, intentando método alternativo..."
    try {
        # Método alternativo usando npx
        npx --yes electron . --dev
    }
    catch {
        Write-Host "Error con npx, intentando método directo..."
        # Método directo
        $electronPath = ".\node_modules\electron\dist\electron.exe"
        if (Test-Path $electronPath) {
            & $electronPath . --dev
        } else {
            Write-Error "No se pudo encontrar el ejecutable de Electron"
            exit 1
        }
    }
}
