Sure! Here’s the README translated into English:

---

# Medieval Fantasy City Generator

This project is an open-source medieval fantasy city generator based on the original [Medieval Fantasy City Generator](https://watabou.itch.io/medieval-fantasy-city-generator/) (also available [here](http://fantasycities.watabou.ru/?size=15&seed=682063530)). This version has been updated to be compatible with the latest versions of the Lime and OpenFL libraries.

This is the very old version 8 years old fixed and improved.

## Prerequisites

To install and run this medieval city generator, you will need:

1. **Haxe** (version 4.2.0 or higher)

   * [Download Haxe from the official website](https://haxe.org/download/)
   * Make sure it is added to your PATH after installation

2. **Haxelib** (comes with Haxe)

3. **Git** (optional, for cloning the repository)

   * [Download Git](https://git-scm.com/downloads)

## Step-by-Step Installation

### 1. Clone or Download the Repository

```powershell
# Using Git
git clone https://github.com/kroryan/TownGeneratorOS.git
cd TownGeneratorOS

# Or download the ZIP manually and extract it
```

### 2. Install Dependencies

Open a terminal (PowerShell or Command Prompt on Windows) and run:

```powershell
# Install Lime
haxelib install lime 8.0.0
haxelib run lime setup

# Install OpenFL
haxelib install openfl 9.2.0
haxelib run openfl setup

# Install msignal
haxelib install msignal 1.2.5
```

### 3. Verify the Installation

To check that everything is correctly installed:

```powershell
haxelib list
```

You should see the installed libraries with their versions:

* lime: \[8.0.0]
* openfl: \[9.2.0]
* msignal: \[1.2.5]

### 4. Compile and Run the Project

#### For HTML5 (web browser)(This way you can use it with azgaar i have an azgaar repository with a branch call TOTALOCAL you can use that one, it is ready):

```powershell
haxelib run openfl test html5
```

This will compile the project and open it in your default browser, usually at `http://localhost:3000`.

#### For desktop application (Neko):

```powershell
haxelib run openfl test neko
```

#### For Windows:

```powershell
haxelib run openfl test windows
```

## Changes Made to Fix Compatibility Issues

The following changes were implemented to solve compatibility problems with the current versions of Lime and OpenFL:

### 1. Dependency Version Updates

Library versions in `project.xml` were updated:

* Lime updated to version 8.0.0 (previously 7.8.0)
* OpenFL updated to version 9.2.0 (previously 9.0.2)

### 2. Data Type Issues Fixed

Main errors fixed were related to data type incompatibilities:

* `lime.utils.Float32Array`, `lime.utils.Int32Array`, and `lime.utils.UInt32Array` should now be `lime.utils.DataPointer` in certain contexts
* `openfl.utils.ByteArray` should be `lime.utils.Bytes` or `lime.utils.BytePointer` depending on context
* Deprecated references to `lime.math.ColorMatrix` and `lime.math.Matrix4` now use `lime.utils.ArrayBufferView`

### 3. Syntax Updates

Most warnings (that did not prevent compilation) were related to obsolete syntax:

* `@:enum abstract` is deprecated and should be replaced with `enum abstract`
* `@:extern` is deprecated and should be replaced with `extern`

Although these warnings appear in library code, not project code, they do not affect functionality.

### 4. WebGL/OpenGL API Fixes

Types in the WebGL/OpenGL APIs were fixed to be compatible with new versions:

* Adjustments in `WebGL2RenderContext` and `NativeOpenGLRenderContext` to use correct types in function arguments

## Using the Generator

1. **Main Interface**: When running the application, you will see an interface where you can select parameters for your city.

2. **City Generation**:

   * Select the city size
   * Click generate to create a new random city

3. **Exploration**:

   * Zoom using the mouse wheel
   * Drag to move around the map
   * The interface includes buttons to generate new cities or modify parameters

## Common Troubleshooting

### Error Installing Lime or OpenFL

If you encounter errors during Lime or OpenFL installation, try:

```powershell
haxelib run lime setup -y
haxelib run openfl setup -y
```

### Compilation Errors

If you encounter type-related errors, verify you are using the correct versions of Lime (8.0.0) and OpenFL (9.2.0) as specified in this README.

### Runtime Errors

If the app compiles but crashes when running, it may be due to:

* Missing resources in the `Assets` folder
* Browser incompatibility (try Chrome if using HTML5)
* WebGL configuration issues on your system

---

## 🏰 Desktop Application (Electron)

In addition to the web version, this project now includes a **complete desktop application** built with Electron that serves as both a standalone desktop app and a local web server.

### Features of the Desktop Application

* **Standalone Desktop App**: Native window with proper menus and icons
* **Local Web Server**: Automatically starts a web server on port 3000
* **Beautiful Loading Screen**: Medieval-themed loading interface with progress indicators
* **Auto-reload System**: Intelligent reloading at 5s and 12s to ensure proper initialization
* **Cross-Platform**: Available for Windows and Linux
* **No Internet Required**: Works completely offline

### Desktop Application Installation

#### Prerequisites for Desktop App

1. **Node.js** (version 16 or higher)
   * [Download Node.js](https://nodejs.org/)
   * Verify installation: `node --version`

2. **NPM** (comes with Node.js)
   * Verify installation: `npm --version`

#### Quick Setup for Desktop App

```powershell
# Navigate to the electron app directory
cd electron-app

# Install dependencies
npm install

# Build the web application
npm run build-web

# Run in development mode
npm run dev

# OR run in production mode
npm start
```

### Web Build System

The desktop application includes an automated web build system that compiles the Haxe/OpenFL project and copies it to the electron app directory.

#### Using the Web Build Script

**From the electron-app directory:**
```powershell
cd electron-app

# Build web application (recommended method)
npm run build-web

# OR run the script directly
node build-web.js
```

**From the project root directory:**
```powershell
# Build web application from root
cd electron-app && npm run build-web && cd ..

# OR combine with Haxe build
haxelib run openfl build html5 && cd electron-app && npm run build-web && cd ..
```

#### What the Web Build Script Does

1. **Compiles Haxe Project**: Runs `haxelib run openfl build html5` 
2. **Locates Build Output**: Finds the compiled files in `Export/html5/bin/`
3. **Copies Files**: Copies all web files to `electron-app/web-build/`
4. **Verifies Build**: Ensures `index.html` and `TownGenerator.js` are present
5. **Reports Status**: Shows success/failure with file paths

#### Manual Web Build (Alternative)

If you prefer to build manually:
```powershell
# 1. Build the Haxe project first
haxelib run openfl build html5

# 2. Copy files manually
cd electron-app
Remove-Item -Path "web-build" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -Path "..\Export\html5\bin" -Destination "web-build" -Recurse

# 3. Verify the build
if (Test-Path "web-build\index.html") { 
    Write-Host "Web build completed successfully" 
} else { 
    Write-Host "Web build failed" 
}
```

#### Troubleshooting Web Build

**Common Issues:**

```powershell
# If build fails, clean and retry
cd electron-app
Remove-Item -Path "web-build" -Recurse -Force -ErrorAction SilentlyContinue
cd ..
haxelib run openfl clean html5
haxelib run openfl build html5
cd electron-app
npm run build-web
```

**Build Script Errors:**
- Ensure you're in the correct directory (`electron-app/`)
- Verify the parent directory contains the OpenFL project
- Check that `Export/html5/bin/` exists after Haxe compilation
- Make sure Node.js has file system permissions

### Compiling Desktop Application

#### For Windows

```powershell
cd electron-app

# Build web application first
npm run build-web

# Compile for Windows (creates installer and portable versions)
npm run build-win
```

This creates:
* **NSIS Installer**: `dist/Medieval-Fantasy-City-Generator Setup 1.0.0.exe`
* **Portable Version**: `dist/Medieval-City-Generator-Portable-1.0.0.exe`

#### For Linux

```powershell
cd electron-app

# Build web application first
npm run build-web

# Compile for Linux
npm run build-linux
```

This creates:
* **AppImage**: `dist/Medieval-Fantasy-City-Generator-1.0.0.AppImage`
* **DEB Package**: `dist/medieval-fantasy-city-generator_1.0.0_amd64.deb`

#### For Both Platforms

```powershell
cd electron-app

# Build web application first
npm run build-web

# Compile for all platforms
npm run build-all
```

### Using the Desktop Application

#### Development Mode

```powershell
cd electron-app
npm run dev
```

* Opens with developer tools enabled
* Automatic console logging
* Hot reload capabilities

#### Production Mode

```powershell
cd electron-app
npm start
```

* Optimized performance
* No developer tools
* Clean user interface

#### Standalone Executables

After compilation, you can run the generated executables:

**Windows:**
* Double-click the `.exe` installer to install the application
* Or run the portable version directly without installation

**Linux:**
* Make the AppImage executable: `chmod +x Medieval-Fantasy-City-Generator-1.0.0.AppImage`
* Run it: `./Medieval-Fantasy-City-Generator-1.0.0.AppImage`
* Or install the DEB package: `sudo dpkg -i medieval-fantasy-city-generator_1.0.0_amd64.deb`

### Desktop Application Features

#### Loading Experience

The desktop app features a beautiful loading screen with:
* Medieval-themed design with castle icon 🏰
* Progressive loading bar (15-second animation)
* Status messages that update every 2.5 seconds
* Automatic reloads at 5s and 12s for optimal initialization
* Smooth transitions and fade effects

#### Menu Options

* **File Menu**:
  * Open in Browser (Ctrl+B) - Opens the web version in your default browser
  * Exit (Ctrl+Q) - Close the application

* **View Menu**:
  * Reload (Ctrl+R) - Refresh the application
  * Force Reload (Ctrl+Shift+R) - Hard refresh ignoring cache
  * Developer Tools (Ctrl+Shift+I) - Open debugging tools
  * Zoom controls and fullscreen toggle

* **Help Menu**:
  * About - Application information
  * Server Information - Details about the local web server
* **Generation menu**:  in the right at botton to avoid the menu in the half of the city image in azgaar ![image](https://github.com/user-attachments/assets/a5d7b803-fbc0-4405-87fd-76c07dc42389)


#### Server Information

The desktop application automatically starts a local web server that:
* Runs on `http://localhost:3000` (or next available port)
* Serves the complete web application
* Can be accessed from any browser on the same computer
* Provides API endpoint at `/api/info` for status checking

### Web Server Mode

You can use the desktop application as a local web server:

1. **Start the desktop application**
2. **Access from any browser** at `http://localhost:3000`
3. **Share with others** on the same network (if firewall allows)

This is perfect for:
* Running the generator on a local network
* Integration with other web applications
* Development and testing purposes
* Using with Azgaar's Fantasy Map Generator (TOTALOCAL branch)

### Compilation Troubleshooting

#### Common Issues

**Permission Errors (Windows):**
```powershell
# Run PowerShell as Administrator if you get permission errors
# Or disable Windows Defender temporarily during compilation
```

**Missing Dependencies:**
```powershell
# Reinstall dependencies
cd electron-app
Remove-Item -Path "node_modules" -Recurse -Force
npm install
```

**Build Failures:**
```powershell
# Clean build directory
cd electron-app
Remove-Item -Path "dist" -Recurse -Force
npm run build-web
npm run build-win
```

**Web Build Issues:**
```powershell
# Ensure OpenFL project is properly built first
cd ..
haxelib run openfl build html5
cd electron-app
npm run build-web
```

#### Build Requirements

* **Windows**: Requires Windows 7 or higher for building Windows targets
* **Linux**: Can build Linux targets on any platform with Node.js
* **Disk Space**: Allow at least 500MB for dependencies and build outputs
* **Internet**: Required for initial dependency download only

### Development Information

#### Project Structure

```
electron-app/
├── main.js              # Main Electron process
├── package.json         # Dependencies and build configuration
├── build-web.js         # Web build automation script
├── assets/              # Application icons and resources
├── web-build/          # Compiled web application (auto-generated)
└── dist/               # Compiled executables (auto-generated)
```

#### Key Files

* **main.js**: Main Electron application with Express server
* **package.json**: Build configuration for electron-builder
* **build-web.js**: Automated script to compile Haxe/OpenFL project
* **assets/**: Icons in multiple formats (SVG, PNG, ICO)

#### Build Process

1. **Web Build**: Compiles Haxe/OpenFL project to HTML5
2. **Copy**: Copies web build to `electron-app/web-build/`
3. **Package**: electron-builder packages the app with web content
4. **Distribute**: Creates installers and portable versions

---

## Additional Technical Notes

* Errors like `lime.utils.X should be lime.utils.DataPointer` relate to Lime API changes where specific typed arrays must now be treated as generic data pointers.

* Warnings about `@:enum abstract` and `@:extern` are syntax changes in Haxe that do not affect functionality but indicate libraries use deprecated syntax.

* The default port for HTML5 mode is 3000 but may change if that port is busy.

---

## Additional Information

* **License**: See LICENSE file
* **Version**: 1.0.0
* **Original Author**: Oleg Dolya (Watabou)
* **Compatibility Update**: May 19, 2025
* **Desktop Application**: June 6, 2025
* **Platforms**: Web (HTML5), Desktop (Windows, Linux), Neko, Windows Native

---

## Integration with Other Tools

### Azgaar's Fantasy Map Generator

This city generator works perfectly with [Azgaar's Fantasy Map Generator](https://github.com/Azgaar/Fantasy-Map-Generator). You can:

1. **Generate a region map** in Azgaar's tool
2. **Mark city locations** on your map
3. **Use this generator** to create detailed city layouts for each marked location
4. **Export both** for use in tabletop RPGs or world-building projects

For the best integration experience, use the TOTALOCAL branch of Azgaar's tool which includes enhanced local connectivity features.

### Usage in Tabletop RPGs

Perfect for:
* **D&D Campaign Preparation**: Generate cities for your adventures
* **Pathfinder**: Create detailed urban environments
* **World Building**: Design consistent medieval fantasy settings
* **Virtual Tabletops**: Export city images for Roll20, Foundry VTT, etc.

---
