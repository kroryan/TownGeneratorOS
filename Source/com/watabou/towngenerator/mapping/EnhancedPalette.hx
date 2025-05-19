package com.watabou.towngenerator.mapping;

class EnhancedPalette extends Palette {
    
    // Color para terreno exterior (granjas y campos)
    public var farmland: Int;
    
    // Color para carreteras y calles
    public var road: Int;
    
    // Colores para diferentes tipos de edificios
    public var stone: Int;
    public var wood: Int;
    public var brick: Int;
    
    // Color para agua (si se implementa)
    public var water: Int;
    
    // Color para el terreno exterior (afueras de la ciudad)
    public var countryside: Int;

    public inline function new(paper, light, medium, dark, farmland, road, stone, wood, brick, water, countryside) {
        super(paper, light, medium, dark);
        this.farmland = farmland;
        this.road = road;
        this.stone = stone;
        this.wood = wood;
        this.brick = brick;
        this.water = water;
        this.countryside = countryside;
    }

    // Paleta mejorada con colores más realistas
    public static var ENHANCED = new EnhancedPalette(
        0xf5f2e9, // papel (fondo)
        0xbfb9ae, // claro 
        0x8c857a, // medio
        0x2a2925, // oscuro
        0x7ea968, // verde para granjas y campos
        0xa2918b, // color carretera
        0xc2b8ae, // piedra
        0xb29b78, // madera
        0xaf6c53, // ladrillo
        0x78a6c5, // agua
        0x90b877  // terreno exterior/countryside (verde más claro)
    );
    
    // Paleta medieval rústica
    public static var RUSTIC = new EnhancedPalette(
        0xf0e6d2, // papel (fondo)
        0xc5b9a5, // claro
        0x927f63, // medio
        0x352a21, // oscuro 
        0x6b8e4e, // verde para granjas y campos
        0x8f7e70, // color carretera
        0xb0a496, // piedra
        0x9b7d56, // madera
        0xa15a46, // ladrillo
        0x5e8ca7, // agua
        0x7da355  // terreno exterior/countryside (verde más oscuro)
    );
    
    // Nueva paleta de fantasía medieval
    public static var FANTASY = new EnhancedPalette(
        0xf7f2e8, // papel (fondo)
        0xc5beac, // claro
        0x969184, // medio
        0x2d2a24, // oscuro
        0x8aae6e, // verde para granjas y campos
        0x967f74, // color carretera
        0xcbc0b3, // piedra
        0xc09e64, // madera
        0xb85f4a, // ladrillo
        0x6ba4c9, // agua
        0x9cc681  // terreno exterior/countryside (verde brillante)
    );
}
