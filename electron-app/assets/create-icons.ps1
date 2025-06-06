# Script para crear iconos simples usando PowerShell
# Este archivo puede ser ejecutado para generar iconos básicos

Write-Host "Creando iconos para la aplicación..."

# Crear un archivo SVG simple para el icono
$svgContent = @"
<svg width="256" height="256" xmlns="http://www.w3.org/2000/svg">
  <rect width="256" height="256" fill="#8B4513"/>
  <rect x="64" y="64" width="128" height="128" fill="#D2691E"/>
  <polygon points="128,32 64,96 192,96" fill="#654321"/>
  <rect x="112" y="144" width="32" height="48" fill="#8B4513"/>
  <rect x="80" y="112" width="16" height="16" fill="#4169E1"/>
  <rect x="160" y="112" width="16" height="16" fill="#4169E1"/>
  <text x="128" y="220" text-anchor="middle" font-family="Arial" font-size="24" fill="#F5DEB3">🏰</text>
</svg>
"@

$svgContent | Out-File -FilePath "icon.svg" -Encoding UTF8

Write-Host "Icono SVG creado: icon.svg"
Write-Host "Para crear iconos ICO y PNG, necesitarás convertir este SVG usando herramientas online o software especializado."
