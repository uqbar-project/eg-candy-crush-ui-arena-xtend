package org.uqbar.arena.examples.apuestas.ui

import org.uqbar.arena.Application
import org.uqbar.arena.examples.apuestas.domain.CandyCrushJuego

class CandyCrushApplication extends Application {
	override createMainWindow() {
		new CandyCrushWindow(this, new CandyCrushJuego)
	}
	
	static def main(String[] args) {
		new CandyCrushApplication().start
	}
}
