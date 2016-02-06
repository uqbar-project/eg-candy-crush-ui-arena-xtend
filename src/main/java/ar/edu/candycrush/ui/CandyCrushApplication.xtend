package ar.edu.candycrush.ui

import org.uqbar.arena.Application
import ar.edu.candycrush.domain.CandyCrushJuego

class CandyCrushApplication extends Application {
	
	override createMainWindow() {
		new CandyCrushWindow(this, new CandyCrushJuego)
	}
	
	static def main(String[] args) {
		new CandyCrushApplication().start
	}
	
}
