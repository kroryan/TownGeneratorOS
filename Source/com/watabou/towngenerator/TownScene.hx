package com.watabou.towngenerator;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.display.Shape;

import com.watabou.coogee.Scene;

import com.watabou.towngenerator.building.Model;
import com.watabou.towngenerator.mapping.CityMap;
import com.watabou.towngenerator.ui.CitySizeButton;
import com.watabou.towngenerator.ui.Button;
import com.watabou.towngenerator.ui.Tooltip;

class TownScene extends Scene {

	private var buttons	: Sprite;
	private var map		: CityMap;
	private var toggleButton : Sprite;
	private var isMenuVisible : Bool = false;

	public function new() {
		super();

		map = new CityMap( Model.instance );
		addChild( map );

		addChild( new Tooltip() );

		// Crear el botón de despliegue
		toggleButton = createToggleButton();
		addChild( toggleButton );
		
		// Crear el contenedor de botones (inicialmente oculto)
		buttons = new Sprite();
		buttons.visible = isMenuVisible;
		addChild( buttons );

		var smallTown = new CitySizeButton( "Small Town", 6, 10 );
		var largeTown = new CitySizeButton( "Large Town", 10, 15 );
		var smallCity = new CitySizeButton( "Small City", 15, 24 );
		var largeCity = new CitySizeButton( "Large City", 24, 40 );

		var pos = 0.0;
		for (btn in [smallTown, largeTown, smallCity, largeCity]) {
			btn.y = pos;
			pos += btn.height + 1;
			buttons.addChild( btn );
		}
	}

	private var scale(get,set) : Float;
	private inline function get_scale():Float
		return map.scaleX;
	private function set_scale( value:Float ):Float
		return (map.scaleX = map.scaleY = value);	private function createToggleButton():Sprite {
		var btn = new Sprite();
		
		// Dibujar un botón circular muy pequeño
		var g = btn.graphics;
		g.beginFill(CityMap.palette.dark);
		g.drawCircle(0, 0, 3); // Mantener el mismo tamaño pequeño
		g.endFill();
		
		// Dibujar un pequeño castillo
		g.lineStyle(0.5, 0xFFFFFF);
		
		// Base del castillo
		g.moveTo(-1.8, 1);
		g.lineTo(1.8, 1);
		
		// Torre izquierda
		g.moveTo(-1.5, 1);
		g.lineTo(-1.5, -0.8);
		g.lineTo(-1.2, -0.8);
		g.lineTo(-1.2, 1);
		
		// Torre central
		g.moveTo(-0.3, 1);
		g.lineTo(-0.3, -1);
		g.lineTo(0.3, -1);
		g.lineTo(0.3, 1);
		
		// Torre derecha
		g.moveTo(1.2, 1);
		g.lineTo(1.2, -0.8);
		g.lineTo(1.5, -0.8);
		g.lineTo(1.5, 1);
		
		// Hacer el botón interactivo
		btn.buttonMode = true;
		btn.addEventListener(MouseEvent.CLICK, onToggleMenu);
		
		return btn;
	}
	
	private function onToggleMenu(e:MouseEvent):Void {
		// Alternar la visibilidad del menú
		isMenuVisible = !isMenuVisible;
		buttons.visible = isMenuVisible;
	}

	override public function layout():Void {
		map.x = rWidth / 2;
		map.y = rHeight / 2;

		var scaleX = rWidth / Model.instance.cityRadius;
		var scaleY = rHeight / Model.instance.cityRadius;		var scMin = Math.min( scaleX, scaleY );
		var scMax = Math.max( scaleX, scaleY );
		scale = (scMax / scMin > 2 ? scMax / 2 : scMin) * 0.5;
		// Posicionar el botón de despliegue (más cerca de la esquina)
		toggleButton.x = rWidth - 5;
		toggleButton.y = rHeight - 5;
		
		// Posicionar el menú de botones
		buttons.x = rWidth - buttons.width - 1;
		buttons.y = rHeight - buttons.height - 15; // Un poco más arriba para no tapar el botón
	}
}
