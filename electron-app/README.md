# Medieval Fantasy City Generator - Electron App

Esta es una aplicación de escritorio para el generador de ciudades medievales, construida con Electron.

## Características

- 🏰 Aplicación de escritorio nativa para Windows y Linux
- 🌐 Servidor web local en puerto 3000
- 🖥️ Acceso tanto desde la aplicación como desde navegador web
- ⚡ Interfaz moderna con menús nativos
- 🔄 Recarga automática y herramientas de desarrollo

## Requisitos

- Node.js (versión 16 o superior)
- NPM
- Haxe y OpenFL (para construir la versión web)

## Instalación y desarrollo

1. **Instalar dependencias:**
   ```bash
   npm install
   ```

2. **Construir la versión web:**
   ```bash
   npm run build-web
   ```

3. **Ejecutar en modo desarrollo:**
   ```bash
   npm run dev
   ```

## Construcción de ejecutables

### Para Windows:
```bash
npm run build-win
```

### Para Linux:
```bash
npm run build-linux
```

### Para ambos:
```bash
npm run build-all
```

Los ejecutables se generarán en el directorio `dist/`.

## Uso

### Aplicación de escritorio
- Ejecuta el archivo generado en `dist/`
- La aplicación se abrirá con la interfaz del generador

### Servidor web
- Mientras la aplicación esté ejecutándose, puedes acceder desde cualquier navegador en:
  - `http://localhost:3000`

### Atajos de teclado
- `Ctrl+N` - Nueva ciudad
- `Ctrl+B` - Abrir en navegador
- `Ctrl+R` - Recargar
- `F12` - Herramientas de desarrollador

## Estructura del proyecto

```
electron-app/
├── main.js          # Proceso principal de Electron
├── package.json     # Configuración del proyecto
├── build-web.js     # Script para construir versión web
├── assets/          # Iconos y recursos
└── web-build/       # Versión web construida (generada)
```

## Notas técnicas

- La aplicación sirve los archivos desde `../Export/html5/bin/` en modo desarrollo
- En producción, los archivos web se empaquetan en `web-build/`
- El servidor web usa Express.js para servir contenido estático
- Si el puerto 3000 está ocupado, automáticamente busca el siguiente disponible
