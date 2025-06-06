const sharp = require('sharp');
const fs = require('fs');
const path = require('path');

async function convertIcons() {
    const svgPath = path.join(__dirname, 'assets', 'icon.svg');
    const assetsDir = path.join(__dirname, 'assets');
    
    console.log('Starting icon conversion...');
    console.log('SVG path:', svgPath);
    console.log('Assets dir:', assetsDir);
    
    // Verificar que el SVG existe
    if (!fs.existsSync(svgPath)) {
        console.error('SVG icon not found at', svgPath);
        return;
    }
    
    console.log('SVG file found! Converting to ICO and PNG formats...');
    
    try {
        // Convertir a PNG para Linux (256x256)
        await sharp(svgPath)
            .resize(256, 256)
            .png()
            .toFile(path.join(assetsDir, 'icon.png'));
        console.log('✓ Created icon.png (256x256)');
        
        // Convertir a PNG para ICO (múltiples tamaños)
        const sizes = [16, 24, 32, 48, 64, 128, 256];
        
        for (const size of sizes) {
            await sharp(svgPath)
                .resize(size, size)
                .png()
                .toFile(path.join(assetsDir, `icon-${size}.png`));
            console.log(`✓ Created icon-${size}.png`);
        }
        
        console.log('Icon conversion completed successfully!');
        console.log('Note: You may need to manually create an ICO file from the PNG files if needed.');
        console.log('For now, we\'ll use PNG format for Windows as well.');
        
        // Copiar el icono principal como .ico (muchos sistemas aceptan PNG renombrado como ICO)
        fs.copyFileSync(path.join(assetsDir, 'icon-256.png'), path.join(assetsDir, 'icon.ico'));
        console.log('✓ Created icon.ico (from 256px PNG)');
        
    } catch (error) {
        console.error('Error converting icons:', error);
    }
}

convertIcons();
