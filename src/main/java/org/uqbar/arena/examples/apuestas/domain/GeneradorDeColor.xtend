package org.uqbar.arena.examples.apuestas.domain

import static extension org.uqbar.arena.examples.apuestas.domain.Extensions.*

interface GeneradorDeColor {
	def Color generarPara(Celda celda)
}

class GeneradorColorRandom implements GeneradorDeColor {
	public static GeneradorColorRandom INSTANCE = new GeneradorColorRandom
	
	override generarPara(Celda celda) {
		Color.COLORES.random
	}
	
}