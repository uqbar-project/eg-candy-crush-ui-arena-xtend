package ar.edu.candycrush.domain

import java.util.Iterator
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable

@Observable
@Accessors
class Tablero {
	int ancho
	int alto
	List<Celda> celdas = newArrayList
	Iterable<Fila> _filas // calculado, como un a "vista" de "celdas"
	GeneradorDeColor generadorColor = GeneradorColorRandom.INSTANCE
	List<TableroListener> listeners = newArrayList 
	
	new(int ancho, int alto) {
		this.ancho = ancho
		this.alto = alto;
		(1..alto).forEach[y| (1..alto).forEach[x| celdas.add(new Celda(this, x,y)) ]]
	}
	
	def popularColores(List<Color> colores) {
		var i = 0
		for(Color c : colores) {
			celdas.get(i).contenido.color = c
			i = i + 1
		}
	}
	
	def void popular() {
		filas.forEach[
			filaArriba.forEach[c| c.llenarSiEstaVacia ]
			Thread.sleep(400)
			filaArriba.forEach[c| c.caer ]
		]
		intentarExplotar()
	}
	
	def void intentarExplotar() {
		explotar
		if (rellenarYCompactar) {
			intentarExplotar
		}
	}
	
	def rellenarYCompactar() {
		var exploto = false
		while (tieneAlgunVacio) {
			exploto = true
			filas.forEach[f| f.compactar]
			filaArriba.llenar
			filaArriba.compactar
		}
		exploto
	}
	
	def explotar() {
		calcularExplosiones.forEach[e| e.realizar]
	}
	
	def calcularExplosiones() {
		//TODO: habría que "filtrar" las intersecciones
		// Ej:  x  
		//		xxx
		//      x
		filas.map[f| f.calcularExplosiones ].flatten.toList
	}

	def isTieneAlgunVacio() {
		filas.exists[f| f.tieneAlgunVacio ]
	}
	
	def getFilas() {
		if (this._filas == null) {
			this._filas = (1..alto).map[i| new Fila(this, i)]
		}
		this._filas
	}
	
	def filaArriba() {	filas.head }
	def filaAbajo() { filas.last }
	
	def celda(int nroFila, int nroColumna) {
		celdas.get(coordenadaAbsoluta(nroColumna, nroFila))
	}
	
	def coordenadaAbsoluta(int x, int y) {
		((y-1) * ancho) + (x - 1)
	}
	
	def vecinaArribaDe(Celda celda) {
		if (celda.y == 1) 	new CeldaFueraDeTablero(this) 
		else 				celda(celda.y - 1, celda.x)
	}
	
	def vecinaAbajoDe(Celda celda) {
		if (celda.y == alto) 	new CeldaFueraDeTablero(this) 
		else 					celda(celda.y + 1, celda.x)
	}
	
	def vecinaIzquierdaDe(Celda celda) {
		if (celda.x == 1) 	new CeldaFueraDeTablero(this) 
		else 				celda(celda.y, celda.x - 1)
	}
	
	def vecinaDerechaDe(Celda celda) {
		if (celda.x == ancho) new CeldaFueraDeTablero(this) 
		else 				  celda(celda.y, celda.x + 1)	
	}
	
	public static int DERECHA = 1
	public static int IZQUIERDA = -1
	
	def Color generarColorPara(Celda celda) {
		generadorColor.generarPara(celda)
	}
	
	def mover(Celda desde, Celda hasta) {
		desde.cambiarCon(hasta)
		if (!realizarExplosiones(desde, hasta)) {
			Thread.sleep(1000)
			desde.cambiarCon(hasta)
		}
	}
	
	def realizarExplosiones(Celda desde, Celda hasta) {
		val exp = #[desde.calcularExplosion, hasta.calcularExplosion]
		exp.forEach[e| e.realizar]
		if (exp.exists[e| e.explotoAlgo]) {
			rellenarYCompactar
			intentarExplotar
			return true
		}
		return false
	}
	
	def notificarExplosion(Explosion explosion) {
		listeners.forEach[l | l.exploto(explosion)]
	}
	
	def addTableroListener(TableroListener listener) {
		listeners.add(listener)
	}
	
}

interface TableroListener {
	
	def void exploto(Explosion explosion)
	
}

@Accessors
class Fila implements Iterable<Celda> {
	int nroFila
	Tablero tablero
	
	new(Tablero tablero, int i) {
		this.nroFila = i
		this.tablero = tablero
	}
	
	override iterator() {
		new FilaIterator(this)
	}
	
	def celda(int nroColumna) {
		tablero.celda(nroFila, nroColumna)
	}
	
	def compactar() {
		forEach[c| c.caer ]
	}
	
	def calcularExplosiones() {
		map[c| c.calcularExplosion ].toList
	}
	
	def isTieneAlgunVacio() {
		exists[c | c.vacia ]
	}
	
	def llenar() {
		forEach[c| c.llenarSiEstaVacia ]
	}
	
}

class FilaIterator implements Iterator<Celda> {
	Fila fila
	int contador = 0
	new(Fila fila) { this.fila = fila	}
	
	override hasNext() {
		contador < fila.tablero.ancho
	}
	
	override next() {
		val c = fila.celda(contador + 1)
		contador = contador + 1
		c
	}
	
	override remove() {
		throw new UnsupportedOperationException("No se pueden eliminar celdas!")
	}

}