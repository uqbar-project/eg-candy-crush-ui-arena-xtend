package ar.edu.candycrush.domain

import static extension ar.edu.candycrush.domain.Extensions.*

interface GeneradorDeColor {
	def Color generarPara(Celda celda)
}

class GeneradorColorRandom implements GeneradorDeColor {
	public static GeneradorColorRandom INSTANCE = new GeneradorColorRandom
	
	override generarPara(Celda celda) {
		Color.COLORES.random
	}
	
}