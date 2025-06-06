const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

async function buildWebVersion() {
    console.log('Building web version with OpenFL...');
    
    const projectPath = path.join(__dirname, '..');
    const exportPath = path.join(projectPath, 'Export', 'html5', 'bin');
    const targetPath = path.join(__dirname, 'web-build');
    
    return new Promise((resolve, reject) => {
        console.log('Running: haxelib run openfl build html5');
        
        // Construir con OpenFL usando el comando correcto
        const buildProcess = spawn('haxelib', ['run', 'openfl', 'build', 'html5'], {
            cwd: projectPath,
            stdio: 'inherit',
            shell: true
        });

        buildProcess.on('close', (code) => {
            if (code === 0) {
                console.log('Web build completed successfully');
                try {
                    copyWebBuild(exportPath, targetPath);
                    resolve();
                } catch (copyError) {
                    reject(copyError);
                }
            } else {
                console.error(`Build failed with code ${code}`);
                reject(new Error(`Build failed with code ${code}`));
            }
        });

        buildProcess.on('error', (error) => {
            console.error('Build process error:', error);
            reject(error);
        });
    });
}

function copyWebBuild(sourcePath, targetPath) {
    try {
        console.log(`Copying web build from ${sourcePath} to ${targetPath}`);
        
        // Crear directorio de destino si no existe
        if (!fs.existsSync(targetPath)) {
            fs.mkdirSync(targetPath, { recursive: true });
        }
        
        // Verificar que el directorio fuente existe
        if (!fs.existsSync(sourcePath)) {
            throw new Error(`Source directory not found: ${sourcePath}`);
        }
        
        // Copiar archivos recursivamente
        copyRecursiveSync(sourcePath, targetPath);
        console.log('Web build copied successfully');
        
    } catch (error) {
        console.error('Error copying web build:', error);
        throw error;
    }
}

function copyRecursiveSync(src, dest) {
    const exists = fs.existsSync(src);
    const stats = exists && fs.statSync(src);
    const isDirectory = exists && stats.isDirectory();
    
    if (isDirectory) {
        if (!fs.existsSync(dest)) {
            fs.mkdirSync(dest);
        }
        fs.readdirSync(src).forEach((childItemName) => {
            copyRecursiveSync(path.join(src, childItemName), path.join(dest, childItemName));
        });
    } else {
        fs.copyFileSync(src, dest);
    }
}

if (require.main === module) {
    buildWebVersion()
        .then(() => {
            console.log('Build and copy completed successfully');
            process.exit(0);
        })
        .catch((error) => {
            console.error('Build failed:', error);
            process.exit(1);
        });
}

module.exports = { buildWebVersion, copyWebBuild };
