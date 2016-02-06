package ar.edu.candycrush.domain

abstract class AbstractExplosion {
	def void realizar()
	def void compactar()
	def Boolean explotoAlgo() { false }
	/** 
	 * Una especia de "getOrElse" de scala
	 * Si esta es una explosion entonces se devuelve ella y no ejecuta el bloque.
	 * En cambio la NoExplosion retorna la ejecución del bloque.
	 * Sirve para encadenar mensajes que producen explosiones, cortando
	 * la ejecución en el primero que genera una explosion.
	 */
	def AbstractExplosion o(() => AbstractExplosion e)
	
}

class Explosion extends AbstractExplosion {
	@Property Iterable<Celda> celdas
	
	new(Iterable<Celda> celdas) {
		this.celdas = celdas
	}
	
	override realizar() {
		celdas.forEach[c| c.explotate]
		celdas.head.tablero.notificarExplosion(this)
		Thread.sleep(200)
	}
	
	override compactar() {
		celdas.forEach[c| c.bajarleContenido ]
	}
	
	override explotoAlgo() { true	}
	
	override o(()=>AbstractExplosion e) {
		this
	}
	
	def getCantidadDeCaramelos() {
		celdas.size
	}

	override toString() {
		"<".concat(celdas.toString).concat(">") 
	}

}

class NoExplosion extends AbstractExplosion {
	public static NoExplosion INSTANCE = new NoExplosion

	override realizar() { }	
	override compactar() { /* no hace nada */ }
	
	override o(()=>AbstractExplosion e) {
		e.apply
	}
	
	override toString() {
		"-"
	}
	
}