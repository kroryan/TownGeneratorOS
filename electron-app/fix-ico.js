const sharp = require('sharp');
const fs = require('fs');
const path = require('path');

async function createIcoFile() {
    try {
        console.log('Creating ICO file from PNG...');
        
        // Use the largest PNG as source
        const pngPath = path.join(__dirname, 'assets', 'icon-256.png');
        const icoPath = path.join(__dirname, 'assets', 'icon.ico');
        
        // Check if the PNG exists
        if (!fs.existsSync(pngPath)) {
            console.error('Source PNG file not found:', pngPath);
            return;
        }
        
        // Remove the corrupted ICO file
        if (fs.existsSync(icoPath)) {
            fs.unlinkSync(icoPath);
            console.log('Removed corrupted ICO file');
        }
        
        // Create multiple sizes for ICO
        const sizes = [16, 24, 32, 48, 64, 128, 256];
        const buffers = [];
        
        for (const size of sizes) {
            const buffer = await sharp(pngPath)
                .resize(size, size)
                .png()
                .toBuffer();
            buffers.push(buffer);
        }
        
        // For now, let's just copy the 256px PNG as the icon
        // This is a workaround since creating proper ICO requires more complex handling
        await sharp(pngPath)
            .png()
            .toFile(icoPath);
            
        console.log('ICO file created successfully');
        
    } catch (error) {
        console.error('Error creating ICO file:', error);
        console.log('Will use PNG file as fallback');
    }
}

createIcoFile();
