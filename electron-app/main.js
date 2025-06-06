const { app, BrowserWindow, Menu, shell, dialog } = require('electron');
const path = require('path');
const express = require('express');
const { spawn } = require('child_process');
const fs = require('fs');
const http = require('http');

class TownGeneratorApp {
    constructor() {
        this.mainWindow = null;
        this.webServer = null;
        this.serverPort = 3000;
        this.isDev = process.argv.includes('--dev');
    }

    async createWindow() {
        // Crear la ventana principal
        this.mainWindow = new BrowserWindow({
            width: 1200,
            height: 900,
            webPreferences: {
                nodeIntegration: false,
                contextIsolation: true,
                enableRemoteModule: false,
                webSecurity: true
            },
            icon: path.join(__dirname, 'assets', 'icon.png'),
            show: false,
            titleBarStyle: 'default',
            title: 'Medieval Fantasy City Generator'
        });

        // Configurar el menú
        this.createMenu();        // Iniciar el servidor web
        await this.startWebServer();

        // Esperar un poco más para que el servidor esté completamente listo
        await this.waitForServerReady();        // Cargar la aplicación
        const startUrl = `http://localhost:${this.serverPort}`;
        
        // Cargar página de loading inicial
        this.loadLoadingPage();

        // Mostrar la ventana cuando esté lista
        this.mainWindow.once('ready-to-show', () => {
            this.mainWindow.show();
            
            if (this.isDev) {
                this.mainWindow.webContents.openDevTools();
            }

            // Mostrar información del servidor
            console.log(`Medieval City Generator running on: ${startUrl}`);
            
            // Iniciar proceso de carga con recargas automáticas
            this.startLoadingProcess(startUrl);
        });

        // Manejar cierre de ventana
        this.mainWindow.on('closed', () => {
            this.mainWindow = null;
            this.stopWebServer();
        });

        // Manejar enlaces externos
        this.mainWindow.webContents.setWindowOpenHandler(({ url }) => {
            shell.openExternal(url);
            return { action: 'deny' };
        });

        // Manejar errores de carga
        this.mainWindow.webContents.on('did-fail-load', (event, errorCode, errorDescription, validatedURL) => {
            console.error('Failed to load:', errorDescription);
            dialog.showErrorBox('Error', `Failed to load application: ${errorDescription}`);
        });
    }

    async startWebServer() {
        return new Promise((resolve, reject) => {
            try {
                const app = express();
                  // Configurar archivos estáticos
                const webBuildPath = this.isDev 
                    ? path.join(__dirname, 'web-build')
                    : path.join(process.resourcesPath, 'web-build');
                
                console.log('Serving files from:', webBuildPath);
                
                // Verificar que el directorio existe
                if (!fs.existsSync(webBuildPath)) {
                    throw new Error(`Web build directory not found: ${webBuildPath}`);
                }
                
                // Servir archivos estáticos
                app.use(express.static(webBuildPath));
                
                // Ruta principal
                app.get('/', (req, res) => {
                    const indexPath = path.join(webBuildPath, 'index.html');
                    if (fs.existsSync(indexPath)) {
                        res.sendFile(indexPath);
                    } else {
                        res.status(404).send('Application not built. Please run the build process first.');
                    }
                });

                // API para información del servidor
                app.get('/api/info', (req, res) => {
                    res.json({
                        name: 'Medieval Fantasy City Generator',
                        version: '1.0.0',
                        port: this.serverPort,
                        status: 'running',
                        platform: process.platform
                    });
                });                // Iniciar servidor
                this.webServer = app.listen(this.serverPort, 'localhost', () => {
                    console.log(`Web server running on http://localhost:${this.serverPort}`);
                    resolve();
                });

                this.webServer.on('error', (err) => {
                    if (err.code === 'EADDRINUSE') {
                        console.log(`Port ${this.serverPort} in use, trying ${this.serverPort + 1}`);
                        this.serverPort++;
                        this.startWebServer().then(resolve).catch(reject);
                    } else {
                        reject(err);
                    }
                });

            } catch (error) {
                reject(error);
            }
        });
    }    async waitForServerReady() {
        // Esperar un poco para asegurar que el servidor esté completamente listo
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Hacer una petición de prueba para verificar que el servidor responde
        return new Promise((resolve) => {
            const checkServer = () => {
                const req = http.get(`http://localhost:${this.serverPort}/api/info`, (res) => {
                    console.log('Server is ready and responding');
                    resolve();
                });
                
                req.on('error', () => {
                    console.log('Server not ready yet, waiting...');
                    setTimeout(checkServer, 200);
                });
                
                req.setTimeout(1000, () => {
                    req.destroy();
                    setTimeout(checkServer, 200);
                });
            };
            checkServer();
        });
    }    scheduleAutoReloads() {
        console.log('Iniciando proceso de carga con pantalla de loading...');
        
        // Primera recarga después de 5 segundos
        setTimeout(() => {
            if (this.mainWindow && !this.mainWindow.isDestroyed()) {
                console.log('Ejecutando primera recarga automática (5s)...');
                this.mainWindow.webContents.reload();
            }
        }, 5000);

        // Segunda recarga después de 12 segundos
        setTimeout(() => {
            if (this.mainWindow && !this.mainWindow.isDestroyed()) {
                console.log('Ejecutando segunda recarga automática (12s)...');
                this.mainWindow.webContents.reload();
            }
        }, 12000);

        // Remover pantalla de loading después de 15 segundos
        setTimeout(() => {
            if (this.mainWindow && !this.mainWindow.isDestroyed()) {
                console.log('Finalizando proceso de carga...');
                this.mainWindow.webContents.executeJavaScript(`
                    const loadingOverlay = document.getElementById('loading-overlay');
                    if (loadingOverlay) {
                        loadingOverlay.style.opacity = '0';
                        setTimeout(() => loadingOverlay.remove(), 500);
                    }
                `);
            }        }, 15000);
    }

    loadLoadingPage() {
        const loadingHTML = `
        <!DOCTYPE html>
        <html lang="es">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Medieval Fantasy City Generator - Cargando</title>
            <style>
                body {
                    margin: 0;
                    padding: 0;
                    background: linear-gradient(135deg, #2c1810, #1a0f08);
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: #d4af37;
                }
                .loading-container {
                    text-align: center;
                    padding: 40px;
                    border: 2px solid #d4af37;
                    border-radius: 15px;
                    background: rgba(0, 0, 0, 0.3);
                    backdrop-filter: blur(10px);
                    box-shadow: 0 0 30px rgba(212, 175, 55, 0.3);
                }
                .loading-title {
                    font-size: 2.5em;
                    margin-bottom: 20px;
                    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
                }
                .loading-text {
                    font-size: 1.2em;
                    margin-bottom: 30px;
                    opacity: 0.8;
                }
                .spinner {
                    width: 60px;
                    height: 60px;
                    border: 4px solid rgba(212, 175, 55, 0.3);
                    border-top: 4px solid #d4af37;
                    border-radius: 50%;
                    animation: spin 1s linear infinite;
                    margin: 0 auto 20px;
                }
                @keyframes spin {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
                .progress-bar {
                    width: 300px;
                    height: 8px;
                    background: rgba(212, 175, 55, 0.2);
                    border-radius: 4px;
                    margin: 20px auto;
                    overflow: hidden;
                }
                .progress-fill {
                    height: 100%;
                    background: linear-gradient(90deg, #d4af37, #f4d03f);
                    width: 0%;
                    animation: progress 15s ease-in-out forwards;
                    border-radius: 4px;
                }
                @keyframes progress {
                    0% { width: 0%; }
                    33% { width: 30%; }
                    66% { width: 60%; }
                    100% { width: 100%; }
                }
                .loading-status {
                    font-size: 0.9em;
                    opacity: 0.7;
                    margin-top: 15px;
                    min-height: 20px;
                }
            </style>
        </head>
        <body>
            <div class="loading-container">
                <div class="loading-title">🏰 Medieval City Generator</div>
                <div class="loading-text">Inicializando el generador de ciudades medievales...</div>
                <div class="spinner"></div>
                <div class="progress-bar">
                    <div class="progress-fill"></div>
                </div>
                <div class="loading-status" id="status">Iniciando servidor local...</div>
            </div>
            
            <script>
                const statusMessages = [
                    'Iniciando servidor local...',
                    'Cargando recursos del juego...',
                    'Preparando generador de mapas...',
                    'Configurando interfaz...',
                    'Optimizando rendimiento...',
                    'Finalizando carga...'
                ];
                
                let currentStatus = 0;
                const statusElement = document.getElementById('status');
                
                const updateStatus = () => {
                    if (currentStatus < statusMessages.length) {
                        statusElement.textContent = statusMessages[currentStatus];
                        currentStatus++;
                        setTimeout(updateStatus, 2500);
                    }
                };
                
                setTimeout(updateStatus, 1000);
            </script>
        </body>
        </html>
        `;
        
        this.mainWindow.loadURL(`data:text/html;charset=utf-8,${encodeURIComponent(loadingHTML)}`);
    }

    startLoadingProcess(startUrl) {
        console.log('Iniciando proceso de carga...');
        
        // Esperar 2 segundos antes de empezar a cargar la aplicación real
        setTimeout(() => {
            this.mainWindow.loadURL(startUrl);
            
            // Agregar overlay de loading a la aplicación real
            this.mainWindow.webContents.once('did-finish-load', () => {
                this.addLoadingOverlay();
                this.scheduleAutoReloads();
            });
        }, 2000);
    }

    addLoadingOverlay() {
        this.mainWindow.webContents.executeJavaScript(`
            // Crear overlay de loading sobre la aplicación
            const overlay = document.createElement('div');
            overlay.id = 'loading-overlay';
            overlay.innerHTML = \`
                <div style="
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(44, 24, 16, 0.95);
                    z-index: 9999;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    transition: opacity 0.5s ease;
                ">
                    <div style="
                        text-align: center;
                        padding: 40px;
                        border: 2px solid #d4af37;
                        border-radius: 15px;
                        background: rgba(0, 0, 0, 0.5);
                        color: #d4af37;
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    ">
                        <div style="font-size: 1.8em; margin-bottom: 15px;">🏰 Cargando Ciudad Medieval</div>
                        <div style="
                            width: 40px;
                            height: 40px;
                            border: 3px solid rgba(212, 175, 55, 0.3);
                            border-top: 3px solid #d4af37;
                            border-radius: 50%;
                            animation: spin 1s linear infinite;
                            margin: 0 auto 15px;
                        "></div>
                        <div style="font-size: 0.9em; opacity: 0.8;">Preparando el generador...</div>
                    </div>
                </div>
                <style>
                    @keyframes spin {
                        0% { transform: rotate(0deg); }
                        100% { transform: rotate(360deg); }
                    }
                </style>
            \`;
            document.body.appendChild(overlay);
        `);
    }

    stopWebServer() {
        if (this.webServer) {
            this.webServer.close();
            this.webServer = null;
            console.log('Web server stopped');
        }
    }

    createMenu() {        const template = [
            {
                label: 'Archivo',
                submenu: [
                    {
                        label: 'Abrir en Navegador',
                        accelerator: 'CmdOrCtrl+B',
                        click: () => {
                            shell.openExternal(`http://localhost:${this.serverPort}`);
                        }
                    },
                    { type: 'separator' },
                    {
                        label: 'Salir',
                        accelerator: process.platform === 'darwin' ? 'Cmd+Q' : 'Ctrl+Q',
                        click: () => {
                            app.quit();
                        }
                    }
                ]
            },
            {
                label: 'Ver',
                submenu: [
                    {
                        label: 'Recargar',
                        accelerator: 'CmdOrCtrl+R',
                        click: () => {
                            this.mainWindow.webContents.reload();
                        }
                    },
                    {
                        label: 'Forzar Recarga',
                        accelerator: 'CmdOrCtrl+Shift+R',
                        click: () => {
                            this.mainWindow.webContents.reloadIgnoringCache();
                        }
                    },
                    {
                        label: 'Herramientas de Desarrollador',
                        accelerator: process.platform === 'darwin' ? 'Alt+Cmd+I' : 'Ctrl+Shift+I',
                        click: () => {
                            this.mainWindow.webContents.toggleDevTools();
                        }
                    },
                    { type: 'separator' },
                    { role: 'resetzoom' },
                    { role: 'zoomin' },
                    { role: 'zoomout' },
                    { type: 'separator' },
                    { role: 'togglefullscreen' }
                ]
            },
            {
                label: 'Ayuda',
                submenu: [
                    {
                        label: 'Acerca de',
                        click: () => {
                            dialog.showMessageBox(this.mainWindow, {
                                type: 'info',
                                title: 'Acerca de',
                                message: 'Medieval Fantasy City Generator',
                                detail: `Versión: 1.0.0\nServidor ejecutándose en: http://localhost:${this.serverPort}\n\nBasado en el original de Oleg Dolya (Watabou)`
                            });
                        }
                    },
                    {
                        label: 'Información del Servidor',
                        click: () => {
                            dialog.showMessageBox(this.mainWindow, {
                                type: 'info',
                                title: 'Información del Servidor',
                                message: 'Estado del Servidor Web',
                                detail: `El servidor local está ejecutándose en:\nhttp://localhost:${this.serverPort}\n\nPuedes acceder al generador desde cualquier navegador en esta computadora usando esta URL.`
                            });
                        }
                    }
                ]
            }
        ];

        const menu = Menu.buildFromTemplate(template);
        Menu.setApplicationMenu(menu);
    }
}

// Instancia de la aplicación
const townGenerator = new TownGeneratorApp();

// Eventos de la aplicación
app.whenReady().then(() => {
    townGenerator.createWindow();

    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) {
            townGenerator.createWindow();
        }
    });
});

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit();
    }
});

app.on('before-quit', () => {
    townGenerator.stopWebServer();
});

// Manejar errores no capturados
process.on('uncaughtException', (error) => {
    console.error('Uncaught Exception:', error);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});
