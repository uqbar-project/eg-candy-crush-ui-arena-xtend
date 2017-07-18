package ar.edu.candycrush.domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable

import static extension ar.edu.candycrush.domain.Extensions.*

@Observable
@Accessors
class CandyCrushJuego implements TableroListener {
	
	Tablero tablero = new Tablero(10, 10)
	Jugador jugador = new Jugador
	Celda celdaSeleccionada
	
	new() {
		this.tablero.addTableroListener(this)
	}
	
	def seleccionarCaramelo(Celda celda) {
		if (celdaSeleccionada == null) {
			celdaSeleccionada = celda
			celda.seleccionada = true
		}
		else {
			tablero.mover(celdaSeleccionada, celda)
			celdaSeleccionada.seleccionada = false
			celdaSeleccionada = null
		}
			
	}
	
	def void crearTablero() {
		tablero.popular
	}
	
	override exploto(Explosion explosion) {
		jugador.puntos = jugador.puntos + (explosion.cantidadDeCaramelos * 10) 
	}
	
}


@Observable
@Accessors
class Celda {
	int x
	int y
	Caramelo contenido
	Tablero tablero
	boolean seleccionada
	
	new(Tablero tablero, Integer x, Integer y) {
		this.x = x
		this.y = y
		this.tablero = tablero
		this.contenido = new Caramelo()
	}
	
	override toString() {
		(x -> y).toString
	}
	
	def cambiarCon(Celda celda) {
		val temp = this.contenido 
		this.contenido = celda.contenido
		celda.contenido = temp
	}
	
	def llenarSiEstaVacia() {
		if (isVacia) contenido.color = Color.COLORES.random
	}
	
	def isVacia() {
		contenido.color == Color.GRIS
	}
	
	def puedoBajarUnCaramelo() {
		isVacia
	}
	
	def void caer() {
		if (isBordeInferior) {
			return
		}
		celdaAbajo.caer
		if (celdaAbajo.puedoBajarUnCaramelo) {
			celdaAbajo.contenido = this.contenido
			this.contenido = new Caramelo
		}
	}
	
	def isBordeInferior() { this.y == tablero.alto }
	def isBordeSuperior() { this.y == 1 }
	def isBordeIzquierdo() { this.x == 1 }
	def isBordeDerecho() { this.x == tablero.ancho }
	def isBorde() { isBordeInferior || isBordeSuperior || isBordeDerecho || isBordeIzquierdo }
	
	def celdaArriba() 		{ tablero.vecinaArribaDe(this) 		}
	def celdaAbajo() 		{ tablero.vecinaAbajoDe(this) 		}
	def celdaIzquierda() 	{ tablero.vecinaIzquierdaDe(this)	}
	def celdaDerecha() 		{ tablero.vecinaDerechaDe(this)		}
	
	def calcularExplosion() {
		if (!isVacia)
			return grupoHorizontal.comoExplosion.o[| grupoVertical.comoExplosion ]
		return NoExplosion.INSTANCE
	}
	
	def grupoHorizontal() { juntarsePorColor[t,c| t.vecinaIzquierdaDe(c)] + #[this] + juntarsePorColor[t,c| t.vecinaDerechaDe(c)] }
	def grupoVertical() { juntarsePorColor[t,c| t.vecinaArribaDe(c)] + #[this] + juntarsePorColor[t,c| t.vecinaAbajoDe(c)] }
	
	def comoExplosion(Iterable<Celda> grupete) {
		if (grupete.size >= 3)
			new Explosion(grupete)
		else 
			NoExplosion.INSTANCE
	}
	
	def explotate() {
		this.contenido.color = Color.GRIS
	}
	
	def juntarsePorColor((Tablero,Celda) => Celda movimiento) {
		val primerVecina = movimiento.apply(tablero, this)
		primerVecina.juntemosDelMismoColor(contenido.color, newArrayList, movimiento)
	}
	
	def List<Celda> juntemosDelMismoColor(Color color, List<Celda> celdas, (Tablero, Celda) => Celda vecina) {
		if (this.contenido.color == color) {
			celdas.add(this)
			vecina.apply(tablero, this).juntemosDelMismoColor(color, celdas, vecina)
		}
		celdas
	}
	
	def coordenadaAbsoluta() {
		tablero.coordenadaAbsoluta(x,y)
	}

	/** toma el contenido de la de arriba y la baja a el */	
	def bajarleContenido() {
		if (isBordeSuperior) {
			generarContenido
		}
		else {
			cambiarCon(celdaArriba)
			celdaArriba.bajarleContenido
		}
	}
	
	def generarContenido() {
		this.contenido.color = tablero.generarColorPara(this)
	}
	
	def color() {
		contenido.color
	}
	
}

class CeldaFueraDeTablero extends Celda {
	
	new(Tablero tablero) {
		super(tablero, 0,0)
		contenido = null
	}
	
	override puedoBajarUnCaramelo() {
		false
	}
	
	override caer() {
	}
	
	override juntemosDelMismoColor(Color color, List<Celda> celdas, (Tablero, Celda)=>Celda vecina) {
		// no sigue hacia ningun lugar buscando
		celdas
	}
		
}

@Observable
@Accessors
class Caramelo {
	Color color = Color.GRIS
	
	def getDescripcion() {
		color.nombre
	}
	
	override toString() {
		descripcion
	}
	
	def isNullCaramelo() {
		color == Color.GRIS
	}
}

@Observable
@Accessors
class Color {
	String nombre
	public static Color GRIS = new Color("GRIS")
	public static Color AZUL = new Color("AZUL")
	public static Color VERDE = new Color("VERDE")
	public static Color ROJO = new Color("ROJO")
	public static Color AMARILLO = new Color("AMARILLO")
	
	public static List<Color> COLORES = #[AZUL, VERDE, ROJO, AMARILLO]
	
	new(String nombre) {
		this.nombre = nombre
	}
	
	override equals(Object obj) {
		obj instanceof Color && (obj as Color).nombre == this.nombre 
	}
	
}

@Observable
@Accessors
class Jugador {
	int puntos
}

