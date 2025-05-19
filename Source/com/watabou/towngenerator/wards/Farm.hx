package com.watabou.towngenerator.wards;

import com.watabou.utils.Random;
import com.watabou.geom.Polygon;
import com.watabou.geom.GeomUtils;
import openfl.geom.Point;

using com.watabou.utils.ArrayExtender;

class Farm extends Ward {

	override public function createGeometry() {
		// Determinamos si es una granja grande o pequeña
		var isLargeFarm = patch.shape.square > 100;
		
		// Localizamos posición para la casa de la granja
		var housing = Polygon.rect(4, 4);
		var pos = GeomUtils.interpolate(patch.shape.random(), patch.shape.centroid, 0.3 + Random.float() * 0.4);
		housing.rotate(Random.float() * Math.PI);
		housing.offset(pos);
		
		// Para granjas grandes, creamos múltiples campos
		if (isLargeFarm) {
			geometry = [];
			
			// Casa principal
			var mainHouse = Ward.createOrthoBuilding(housing, 8, 0.5);
			geometry = geometry.concat(mainHouse);
			
			// División de campos para cultivos
			var fieldType = Random.int(0, 2); // 0: rectangular, 1: radial, 2: irregular
					switch (fieldType) {				case 0: // Campos rectangulares
					var numDivisions = 2 + Random.int(0, 3);
					
					// Creamos un polígono principal para el campo
					var fieldPolygon = new Polygon(patch.shape.copy());
					
					// Añadimos este campo como geometría
					geometry.push(fieldPolygon);
					
					// Y añadimos algunas subdivisiones para simular campos cultivados
					for (i in 0...numDivisions) {
						// Creamos un nuevo polígono más pequeño dentro del campo principal
						var subFieldPoints = [];
						var fieldCenter = patch.shape.centroid;
						var fieldRadius = patch.shape.perimeter * 0.2;
						
						// Creamos polígonos rectangulares dentro del campo
						var angle = Random.float() * Math.PI;
						var width = fieldRadius * (0.3 + Random.float() * 0.3);
						var height = fieldRadius * (0.3 + Random.float() * 0.3);
						
						// Generamos los puntos del rectángulo girado
						for (j in 0...4) {
							var cornerAngle = angle + j * Math.PI / 2;
							var offsetX = Math.cos(cornerAngle) * (j % 2 == 0 ? width : height);
							var offsetY = Math.sin(cornerAngle) * (j % 2 == 0 ? width : height);
							subFieldPoints.push(new Point(
								fieldCenter.x + offsetX,
								fieldCenter.y + offsetY
							));
						}
						
						// Añadimos este subcampo como geometría
						geometry.push(new Polygon(subFieldPoints));
					}
							case 1: // Campos radiales
					// Creamos campos que irradian desde un punto central
					var center = patch.shape.centroid;
					var numSectors = 3 + Random.int(0, 4);
					
					for (i in 0...numSectors) {
						var startAngle = i * 2 * Math.PI / numSectors;
						var endAngle = (i + 1) * 2 * Math.PI / numSectors;
						
						var points = [center];
						
						// Generamos puntos en el perímetro para el sector
						var numPointsOnEdge = 3 + Random.int(0, 2);
						for (j in 0...numPointsOnEdge) {
							var angle = startAngle + (endAngle - startAngle) * j / (numPointsOnEdge - 1);
							var radius = patch.shape.perimeter * 0.2;
							var point = new Point(
								center.x + Math.cos(angle) * radius,
								center.y + Math.sin(angle) * radius
							);
							points.push(point);
						}
						
						// Creamos el polígono y lo añadimos
						var fieldPolygon = new Polygon(points);
						geometry.push(fieldPolygon);
					}
					
				case 2: // Campos irregulares
					// Simplemente usamos el polígono original como un campo
					geometry.push(patch.shape.copy());
					
					// Y añadimos algunos polígonos menores dentro
					var numSubfields = 2 + Random.int(0, 3);
					for (i in 0...numSubfields) {
						var points = [];
						var numPoints = 3 + Random.int(0, 4);
						var centerVariation = patch.shape.perimeter * 0.2;
						var center = new Point(
							patch.shape.centroid.x + (Random.float() - 0.5) * centerVariation,
							patch.shape.centroid.y + (Random.float() - 0.5) * centerVariation
						);
						
						for (j in 0...numPoints) {
							var angle = j * 2 * Math.PI / numPoints;
							var radius = 10 + Random.float() * 15;
							points.push(new Point(
								center.x + Math.cos(angle) * radius,
								center.y + Math.sin(angle) * radius
							));
						}
						
						geometry.push(new Polygon(points));
					}
			}
		} else {
			// Para granjas pequeñas, mantenemos el comportamiento original
			geometry = Ward.createOrthoBuilding(housing, 8, 0.5);
		}
	}

	override public inline function getLabel() return "Farm";
}
