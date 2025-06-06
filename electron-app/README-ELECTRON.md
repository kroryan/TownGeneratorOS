# 🏰 Medieval Fantasy City Generator - Aplicación Electron

Aplicación de escritorio construida con Electron para el Generador de Ciudades Medievales.

## ⚡ Inicio Rápido

```powershell
# Instalar dependencias
npm install

# Construir aplicación web
npm run build-web

# Ejecutar en desarrollo
npm run dev

# Compilar ejecutables
npm run build-win    # Para Windows
npm run build-linux  # Para Linux
npm run build-all    # Para ambos
```

## 📁 Archivos Generados

- **Windows**: `dist/Medieval-Fantasy-City-Generator Setup 1.0.0.exe` (instalador)
- **Windows**: `dist/Medieval-City-Generator-Portable-1.0.0.exe` (portable)
- **Linux**: `dist/Medieval-Fantasy-City-Generator-1.0.0.AppImage`
- **Linux**: `dist/medieval-fantasy-city-generator_1.0.0_amd64.deb`

## 🌐 Servidor Web

La aplicación incluye un servidor web local en `http://localhost:3000` que permite:

- Usar el generador desde cualquier navegador
- Integración con otras herramientas web
- Acceso desde múltiples dispositivos en la red local

## 📖 Documentación Completa

Ver el [README principal](../README.md) para documentación detallada sobre:

- Instalación de prerrequisitos
- Guías de compilación paso a paso
- Solución de problemas
- Características avanzadas
- Integración con otras herramientas

## 🔧 Configuración de Desarrollo

```powershell
# Modo desarrollo con herramientas de debug
npm run dev

# Modo producción
npm start
```

**Nota**: Asegúrate de haber compilado primero la versión web con `npm run build-web` antes de compilar los ejecutables.
