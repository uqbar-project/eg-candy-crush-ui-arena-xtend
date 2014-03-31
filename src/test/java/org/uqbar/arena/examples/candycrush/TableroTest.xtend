package org.uqbar.arena.examples.candycrush

import static extension junit.framework.Assert.*

import org.junit.Test
import org.uqbar.arena.examples.apuestas.domain.Tablero

import static org.uqbar.arena.examples.apuestas.domain.Color.*
import org.uqbar.arena.examples.apuestas.domain.CandyCrushJuego
import org.uqbar.arena.examples.apuestas.domain.CeldaFueraDeTablero

class TableroTest {
	
	@Test
	def void testEstructuraSimpleFilasYColumnas() {
		val tablero = new Tablero(5, 5)
		assertEquals(5, tablero.filas.size)
		assertTrue(tablero.filas.forall[f| f.size == tablero.ancho])
	}
	
	@Test
	def void testVecinosDeCeldas() {
		val tablero = new Tablero(5, 5)
		val medio = tablero.celda(3,3)
		
		tablero.vecinaArribaDe(medio) => [
			(y -> x).assertEquals(2 -> 3)
			tablero.vecinaArribaDe(it) => [
				(y -> x).assertEquals(1 -> 3)
				tablero.vecinaArribaDe(it) => [
					(it instanceof CeldaFueraDeTablero).assertTrue
				]
			]
		]
				
	}
	
	@Test
	def void testVecinasValidas() {
		val tablero = new Tablero(5, 5)
		val celdaCentro = tablero.celda(3, 3)
		celdaCentro.celdaArriba => [
			3.assertEquals(x)
			2.assertEquals(y)
		]
		celdaCentro.celdaAbajo => [
			3.assertEquals(x)
			4.assertEquals(y)
		]
		celdaCentro.celdaIzquierda => [
			2.assertEquals(x)
			3.assertEquals(y)
		]
		celdaCentro.celdaDerecha => [
			4.assertEquals(x)
			3.assertEquals(y)
		]
	}
	
	@Test
	def void testExplosionSinMovimientoSimpleHorizontal() {
		val tablero = new Tablero(5, 5)
		tablero.popularColores(#[
			VERDE, 	VERDE, 		VERDE, 		AMARILLO, 		AMARILLO,
			ROJO, 	VERDE, 		VERDE, 		AMARILLO, 		AMARILLO,
			VERDE, 	AMARILLO, 	AMARILLO,	ROJO,			ROJO
		])
		tablero.explotar()
		// la primer linea tiene una explosion de verdes!
		tablero.celda(1,1).isVacia.assertTrue
		tablero.celda(1,2).isVacia.assertTrue
		tablero.celda(1,3).isVacia.assertTrue
	}
	
	@Test
	def void testExplotarRegeneraCaramelosEnLaFilaDeArriba() {
		val tablero = new Tablero(5, 5)
		tablero.popularColores(#[
			VERDE, 	VERDE, 		VERDE, 		AMARILLO, 		AMARILLO,
			ROJO, 	VERDE, 		VERDE, 		AMARILLO, 		AMARILLO,
			VERDE, 	AMARILLO, 	AMARILLO,	ROJO,			ROJO
		])
		tablero.intentarExplotar
		// la primer linea tiene una explosion de verdes, pero se regenera
		tablero.celda(1,1).isVacia.assertFalse
		tablero.celda(1,2).isVacia.assertFalse
		tablero.celda(1,3).isVacia.assertFalse
		tablero.tieneAlgunVacio.assertFalse
	}

	@Test	
	def void testMovimientoHorizontalYExplotan3Horizontales() {
		val tablero = new Tablero(5, 5)
		tablero.popularColores(#[
			AMARILLO, 	VERDE, 		VERDE, 		AMARILLO, 		VERDE,
			ROJO, 		VERDE, 		VERDE, 		AMARILLO, 		ROJO,
			VERDE, 		ROJO, 	AMARILLO,		ROJO,			ROJO  // <-- ACA LOS ROJOS
		])
		tablero.mover(tablero.celda(3, 2), tablero.celda(3, 3))
		// explota !
		AMARILLO.equals(tablero.celda(3,2).color) // el intercambiado
		// los que bajaron
		VERDE.equals(tablero.celda(3,3).color)
		AMARILLO.equals(tablero.celda(3,4).color)
		ROJO.equals(tablero.celda(3,5).color)
	}
	
}