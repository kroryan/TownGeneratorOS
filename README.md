# Medieval Fantasy City Generator

Este proyecto es un generador de ciudades medievales de fantasía de código abierto basado en el [Medieval Fantasy City Generator](https://watabou.itch.io/medieval-fantasy-city-generator/) original (también disponible [aquí](http://fantasycities.watabou.ru/?size=15&seed=682063530)). Esta versión ha sido actualizada para ser compatible con las últimas versiones de las librerías Lime y OpenFL.

## Requisitos Previos

Para instalar y ejecutar este generador de ciudades medievales necesitarás:

1. **Haxe** (versión 4.2.0 o superior)
   - [Descargar Haxe desde su sitio oficial](https://haxe.org/download/)
   - Asegúrate de que esté en tu PATH después de la instalación

2. **Haxelib** (viene con Haxe)

3. **Git** (opcional, para clonar el repositorio)
   - [Descargar Git](https://git-scm.com/downloads)

## Instalación Paso a Paso

### 1. Clonar o Descargar el Repositorio

```powershell
# Usando Git
git clone https://github.com/usuario/TownGeneratorOS.git
cd TownGeneratorOS

# O descarga el ZIP manualmente y extráelo
```

### 2. Instalar las Dependencias

Abre una terminal (PowerShell o Command Prompt en Windows) y ejecuta:

```powershell
# Instalar Lime
haxelib install lime 8.0.0
haxelib run lime setup

# Instalar OpenFL
haxelib install openfl 9.2.0
haxelib run openfl setup

# Instalar msignal
haxelib install msignal 1.2.5
```

### 3. Probar la Instalación

Para verificar que todo está correctamente instalado:

```powershell
haxelib list
```

Deberías ver las librerías instaladas con sus respectivas versiones:
- lime: [8.0.0]
- openfl: [9.2.0]
- msignal: [1.2.5]

### 4. Compilar y Ejecutar el Proyecto

#### Para HTML5 (navegador web):

```powershell
haxelib run openfl test html5
```

Esto compilará el proyecto y lo abrirá en tu navegador predeterminado, normalmente en `http://localhost:3000`.

#### Para aplicación de escritorio (Neko):

```powershell
haxelib run openfl test neko
```

#### Para Windows:

```powershell
haxelib run openfl test windows
```

## Cambios Realizados para Solucionar Problemas de Compatibilidad

Los siguientes cambios fueron implementados para solucionar problemas de compatibilidad con las versiones actuales de Lime y OpenFL:

### 1. Actualización de Versiones de Dependencias

Se actualizaron las versiones de las librerías en el archivo `project.xml`:
- Lime actualizado a la versión 8.0.0 (anteriormente 7.8.0)
- OpenFL actualizado a la versión 9.2.0 (anteriormente 9.0.2)

### 2. Resolución de Problemas con Tipos de Datos

Los principales errores corregidos estaban relacionados con incompatibilidades entre tipos de datos:
- `lime.utils.Float32Array`, `lime.utils.Int32Array`, y `lime.utils.UInt32Array` ahora deben ser `lime.utils.DataPointer` en ciertos contextos
- `openfl.utils.ByteArray` debe ser `lime.utils.Bytes` o `lime.utils.BytePointer` según el contexto
- Las referencias obsoletas de `lime.math.ColorMatrix` y `lime.math.Matrix4` ahora usan `lime.utils.ArrayBufferView`

### 3. Actualizaciones de Sintaxis

La mayoría de las advertencias (que no impedían la compilación) se relacionaban con sintaxis obsoleta:
- `@:enum abstract` está obsoleto y debe reemplazarse por `enum abstract`
- `@:extern` está obsoleto y debe reemplazarse por `extern`

Aunque estas advertencias aparecen en el código de las bibliotecas y no en el código del proyecto, no afectan la funcionalidad.

### 4. Correcciones en APIs WebGL/OpenGL

Se corrigieron tipos en las API de WebGL/OpenGL para que fueran compatibles con las nuevas versiones:
- Ajustes en `WebGL2RenderContext` y `NativeOpenGLRenderContext` para usar los tipos correctos en los argumentos de funciones

## Uso del Generador

1. **Interfaz Principal**: Al ejecutar la aplicación, verás una interfaz donde puedes seleccionar parámetros para tu ciudad.

2. **Generación de la Ciudad**: 
   - Selecciona el tamaño de la ciudad
   - Haz clic en generar para crear una nueva ciudad aleatoria

3. **Exploración**:
   - Puedes hacer zoom utilizando la rueda del ratón
   - Arrastra para moverte por el mapa
   - La interfaz incluye botones para generar nuevas ciudades o modificar parámetros

## Resolución de Problemas Comunes

### Error al Instalar Lime o OpenFL

Si encuentras errores durante la instalación de Lime u OpenFL, intenta:

```powershell
haxelib run lime setup -y
haxelib run openfl setup -y
```

### Errores de Compilación

Si encuentras errores relacionados con tipos, verifica que estés usando las versiones correctas de Lime (8.0.0) y OpenFL (9.2.0) especificadas en este README.

### Errores en Tiempo de Ejecución

Si la aplicación se compila pero falla al ejecutarse, puede deberse a:
- Recursos faltantes en la carpeta `Assets`
- Incompatibilidades con el navegador (prueba con Chrome si usas HTML5)
- Problemas con la configuración de WebGL en tu sistema

---

## Notas Técnicas Adicionales

- Los errores de tipo `lime.utils.X should be lime.utils.DataPointer` están relacionados con cambios en la API de Lime donde arrays tipados específicos ahora deben ser tratados como punteros de datos genéricos.

- Las advertencias sobre `@:enum abstract` y `@:extern` son cambios de sintaxis en Haxe que no afectan la funcionalidad, pero que indican que las bibliotecas utilizan sintaxis obsoleta.

- El puerto predeterminado para ejecución en modo HTML5 es el 3000, pero podría cambiar si ese puerto está ocupado.

---

## Información Adicional

- **Licencia**: Ver archivo LICENSE
- **Versión**: 0.0.1
- **Autor Original**: Oleg Dolya (Watabou)
- **Actualización de Compatibilidad**: 19 de mayo de 2025
