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
git clone https://github.com/kroryen/TownGeneratorOS.git
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

## Additional Technical Notes

* Errors like `lime.utils.X should be lime.utils.DataPointer` relate to Lime API changes where specific typed arrays must now be treated as generic data pointers.

* Warnings about `@:enum abstract` and `@:extern` are syntax changes in Haxe that do not affect functionality but indicate libraries use deprecated syntax.

* The default port for HTML5 mode is 3000 but may change if that port is busy.

---

## Additional Information

* **License**: See LICENSE file
* **Version**: 0.0.1
* **Original Author**: Oleg Dolya (Watabou)
* **Compatibility Update Date**: May 19, 2025

---
