package com.watabou.towngenerator.mapping;

import openfl.display.Shape;
import openfl.display.CapsStyle;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.geom.Point;

import com.watabou.geom.Polygon;
import com.watabou.utils.Random;

import com.watabou.towngenerator.wards.*;
import com.watabou.towngenerator.building.CurtainWall;
import com.watabou.towngenerator.building.Model;

using com.watabou.utils.ArrayExtender;
using com.watabou.utils.GraphicsExtender;
using com.watabou.utils.PointExtender;

class CityMap extends Sprite {

	public static var palette = EnhancedPalette.FANTASY; // Usamos la nueva paleta de fantasía

	private var patches	: Array<PatchView>;

	private var brush	: Brush;

	public function new( model:Model ) {
		super();

		brush = new Brush( palette );
		
		var enhancedPalette = cast(palette, EnhancedPalette);
		
		// Dibujamos el terreno exterior primero (detrás de todo lo demás)
		var background = new Shape();
		drawTerrain(background.graphics, model, enhancedPalette);
		addChild(background);

		var model = Model.instance;
		
		// Dibujamos caminos rurales primero (debajo de las ciudades)
		for (road in model.roads) {
			var roadView = new Shape();
			drawRoad( roadView.graphics, road );
			addChild( roadView );
		}

		patches = [];
		for (patch in model.patches) {
			var patchView = new PatchView( patch );
			var patchDrawn = true;

			var g = patchView.graphics;
			switch (Type.getClass( patch.ward )) {
				case Castle:
					// Castillos de piedra
					drawBuilding( g, patch.ward.geometry, enhancedPalette.stone, palette.dark, Brush.NORMAL_STROKE * 2 );
				case Cathedral:
					// Catedrales de piedra
					drawBuilding( g, patch.ward.geometry, enhancedPalette.stone, palette.dark, Brush.NORMAL_STROKE );
				case Market:
					// Mercados de madera
					drawBuildingWithVariation( g, patch.ward.geometry, enhancedPalette.wood, palette.dark, true );
				case CraftsmenWard:
					// Artesanos con variación de materiales
					drawBuildingWithVariation( g, patch.ward.geometry, enhancedPalette.wood, palette.dark, false );
				case MerchantWard:
					// Comerciantes con edificios más elaborados
					drawBuildingWithVariation( g, patch.ward.geometry, enhancedPalette.brick, palette.dark, false );
				case PatriciateWard:
					// Nobles con edificios de piedra
					drawBuilding( g, patch.ward.geometry, enhancedPalette.stone, palette.dark, Brush.NORMAL_STROKE * 1.2 );
				case AdministrationWard:
					// Administración con edificios de ladrillo
					drawBuilding( g, patch.ward.geometry, enhancedPalette.brick, palette.dark, Brush.NORMAL_STROKE * 1.1 );
				case MilitaryWard:
					// Cuarteles de piedra con estructura sólida
					drawBuilding( g, patch.ward.geometry, enhancedPalette.stone, palette.dark, Brush.NORMAL_STROKE * 1.5 );
				case GateWard:
					// Barrios de la puerta con materiales variados
					drawBuildingWithVariation( g, patch.ward.geometry, enhancedPalette.brick, palette.dark, false );
				case Slum:
					// Barrios pobres con materiales humildes
					brush.setColor( g, enhancedPalette.wood, palette.dark, Brush.THIN_STROKE );
					for (building in patch.ward.geometry)
						g.drawPolygon( building );
				case Farm:
					// Granjas con color verde de cultivos y una casa
					brush.setColor( g, enhancedPalette.farmland, enhancedPalette.farmland, Brush.THIN_STROKE );
					for (building in patch.ward.geometry) {
						g.drawPolygon( building );
					}
					// Dibujamos una casa principal en cada granja
					if (patch.ward.geometry.length > 0) {
						var farm = patch.ward.geometry[0];
						brush.setColor( g, enhancedPalette.wood, palette.dark );
						g.drawPolygon( farm );
					}
				case Park:
					// Parques verdes
					brush.setColor( g, enhancedPalette.farmland, enhancedPalette.farmland, Brush.THIN_STROKE );
					for (grove in patch.ward.geometry)
						g.drawPolygon( grove );
				default:
					patchDrawn = false;
			}

			patches.push( patchView );
			if (patchDrawn)
				addChild( patchView );
		}

		for (patch in patches)
			addChild( patch.hotArea );

		var walls = new Shape();
		addChild( walls );

		if (model.wall != null)
			drawWall( walls.graphics, model.wall, false );

		if (model.citadel != null)
			drawWall( walls.graphics, cast( model.citadel.ward, Castle).wall, true );
			
		// Dibujamos las calles de la ciudad encima de todo
		for (street in model.streets) {
			var streetView = new Shape();
			drawRoad( streetView.graphics, street );
			addChild( streetView );
		}
	}
		/**
	 * Dibuja el terreno exterior y alrededores de la ciudad
	 * @param graphics Graphics donde dibujar
	 * @param model Modelo de la ciudad
	 * @param enhancedPalette Paleta de colores
	 */
	private function drawTerrain( graphics:Graphics, model:Model, enhancedPalette:EnhancedPalette ):Void {
		// Calculamos un radio más grande que la ciudad para dibujar el terreno
		var outskirtsRadius = model.cityRadius * 2.5;
		
		// Dibujamos un círculo grande como fondo para el terreno exterior
		graphics.beginFill(enhancedPalette.countryside);
		graphics.drawCircle(0, 0, outskirtsRadius);
		graphics.endFill();
		
		// Añadimos variedad con manchas aleatorias de terreno
		for (i in 0...50) {
			var angle = Random.float() * Math.PI * 2;
			var distance = model.cityRadius * (1.2 + Random.float() * 1.3);
			var x = Math.cos(angle) * distance;
			var y = Math.sin(angle) * distance;
			var size = 4 + Random.float() * 10;
			
			// Variamos ligeramente el tono del verde
			var colorShift = Random.int(-15, 15);
			var r = ((enhancedPalette.countryside >> 16) & 0xFF) + colorShift;
			var green = ((enhancedPalette.countryside >> 8) & 0xFF) + colorShift;
			var b = (enhancedPalette.countryside & 0xFF) + colorShift;
					// Mantenemos los colores en el rango válido
			r = Std.int(Math.max(0, Math.min(255, r)));
			green = Std.int(Math.max(0, Math.min(255, green)));
			b = Std.int(Math.max(0, Math.min(255, b)));
			
			var color = (r << 16) | (green << 8) | b;
			
			// Dibujamos manchas irregulares
			brush.setFill(graphics, color);
			brush.noStroke(graphics);
			
			if (Random.bool(0.7)) {
				// Círculos irregulares
				graphics.drawCircle(x, y, size * (0.8 + Random.float() * 0.4));
			} else {
				// Formas poligonales
				var points = [];
				var numPoints = 5 + Random.int(0, 3);
				for (j in 0...numPoints) {
					var a = j * Math.PI * 2 / numPoints;
					var radius = size * (0.8 + Random.float() * 0.4);
					points.push(new Point(
						x + Math.cos(a) * radius,
						y + Math.sin(a) * radius
					));
				}
				graphics.drawPolygon(new Polygon(points));
			}
		}
		
		// Si hay agua, dibujamos algunas manchas de agua
		if (model.waterbody != null && model.waterbody.length > 0) {
			for (waterPatch in model.waterbody) {
				brush.setFill(graphics, enhancedPalette.water);
				brush.setStroke(graphics, palette.dark, Brush.THIN_STROKE);
				graphics.drawPolygon(waterPatch.shape);
			}
		}
	}
	
	private function drawRoad( g:Graphics, road:Street ):Void {
		// Usamos el color específico para carreteras
		var enhancedPalette = cast(palette, EnhancedPalette);
		g.lineStyle( Ward.MAIN_STREET + Brush.NORMAL_STROKE, enhancedPalette.road, false, null, CapsStyle.NONE );
		g.drawPolyline( road );

		// El centro del camino es más claro
		g.lineStyle( Ward.MAIN_STREET - Brush.NORMAL_STROKE, palette.paper );
		g.drawPolyline( road );
	}

	private function drawWall( g:Graphics, wall:CurtainWall, large:Bool ):Void {
		g.lineStyle( Brush.THICK_STROKE, palette.dark );
		g.drawPolygon( wall.shape );

		for (gate in wall.gates)
			drawGate( g, wall.shape, gate );

		for (t in wall.towers)
			drawTower( g, t, Brush.THICK_STROKE * (large ? 1.5 : 1) );
	}

	private function drawTower( g:Graphics, p:Point, r:Float ) {
		brush.noStroke( g );
		g.beginFill( palette.dark );
		g.drawCircle( p.x, p.y, r );
		g.endFill();
	}

	private function drawGate( g:Graphics, wall:Polygon, gate:Point ) {
		g.lineStyle( Brush.THICK_STROKE * 2, palette.dark, false, null, CapsStyle.NONE );

		var dir = wall.next( gate ).subtract( wall.prev( gate ) );
		dir.normalize( Brush.THICK_STROKE * 1.5 );
		g.moveToPoint( gate.subtract( dir ) );
		g.lineToPoint( gate.add( dir ) );
	}

	private function drawBuilding( g:Graphics, blocks:Array<Polygon>, fill:Int, line:Int, thickness:Float ):Void {
		brush.setStroke( g, line, thickness * 2 );
		for (block in blocks) {
			g.drawPolygon( block );
		}

		brush.noStroke( g );
		brush.setFill( g, fill );
		for (block in blocks) {
			g.drawPolygon( block );
		}
	}
	
	/**
	 * Dibuja un conjunto de edificios con variaciones de colores para mayor realismo
	 * @param g Graphics donde dibujar
	 * @param blocks Polígonos que representan edificios
	 * @param baseFill Color base para los edificios
	 * @param line Color de las líneas
	 * @param importantBuildings Si deben dibujarse como edificios importantes (más detalle)
	 */
	private function drawBuildingWithVariation( g:Graphics, blocks:Array<Polygon>, baseFill:Int, line:Int, importantBuildings:Bool ):Void {
		// Obtenemos los colores alternativos (madera/piedra/ladrillo)
		var enhancedPalette = cast(palette, EnhancedPalette);
		var altFill:Array<Int> = [enhancedPalette.stone, enhancedPalette.wood, enhancedPalette.brick];
		
		for (block in blocks) {
			// Determinamos si este edificio debe tener un color alternativo basado en aleatoriedad
			var useDifferentColor = Random.bool(0.35);
			var fillColor:Int = useDifferentColor ? altFill[Random.int(0, altFill.length - 1)] : baseFill;
			
			// Dibujamos contorno con grosor variable según importancia del edificio
			var strokeThickness = importantBuildings ? Brush.NORMAL_STROKE * 1.5 : Brush.NORMAL_STROKE;
			brush.setStroke(g, line, strokeThickness * 2);
			g.drawPolygon(block);
			
			// Rellenamos el edificio con el color seleccionado
			brush.noStroke(g);
			brush.setFill(g, fillColor);
			g.drawPolygon(block);
			
			// Para edificios importantes, agregamos más detalles
			if (importantBuildings && block.square > 10) {
				// Dibujamos un pórtico o entrada en los edificios grandes
				var centroid = block.centroid;
				var smallestDist = Math.POSITIVE_INFINITY;
				var closestEdge:Point = null;
				
				// Encontramos el borde más cercano al centro para colocar una entrada
				block.forEdge(function(v1, v2) {
					var midPoint = new Point((v1.x + v2.x) / 2, (v1.y + v2.y) / 2);
					var dist = Point.distance(midPoint, centroid);
					if (dist < smallestDist) {
						smallestDist = dist;
						closestEdge = midPoint;
					}
				});
				
				if (closestEdge != null) {
					var direction = closestEdge.subtract(centroid);
					direction.normalize(block.perimeter * 0.05);
					
					// Dibujamos una pequeña entrada
					g.beginFill(line);
					g.drawCircle(centroid.x + direction.x * 0.6, centroid.y + direction.y * 0.6, Brush.NORMAL_STROKE);
					g.endFill();
				}
			}
		}
	}
}