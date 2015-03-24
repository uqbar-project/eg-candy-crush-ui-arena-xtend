package org.uqbar.arena.examples.apuestas.ui

import java.awt.Color
import org.uqbar.arena.bindings.Transformer

final class CeldaColorTransformer implements Transformer<org.uqbar.arena.examples.apuestas.domain.Color, Color> {

	override getModelType() {
		typeof(org.uqbar.arena.examples.apuestas.domain.Color)
	}

	override getViewType() {
		typeof(Color)
	}

	override modelToView(org.uqbar.arena.examples.apuestas.domain.Color valueFromModel) {
		switch (valueFromModel) {
			case org.uqbar.arena.examples.apuestas.domain.Color.AZUL: Color.BLUE
			case org.uqbar.arena.examples.apuestas.domain.Color.AMARILLO: Color.YELLOW
			case org.uqbar.arena.examples.apuestas.domain.Color.VERDE: Color.GREEN
			case org.uqbar.arena.examples.apuestas.domain.Color.ROJO: Color.RED
			case org.uqbar.arena.examples.apuestas.domain.Color.GRIS: Color.GRAY
		}
	}

	override viewToModel(Color valueFromView) {
		switch (valueFromView) {
			case Color.BLUE : org.uqbar.arena.examples.apuestas.domain.Color.AZUL
			case Color.YELLOW : org.uqbar.arena.examples.apuestas.domain.Color.AMARILLO
			case Color.GREEN : org.uqbar.arena.examples.apuestas.domain.Color.VERDE
			case Color.RED : org.uqbar.arena.examples.apuestas.domain.Color.ROJO
			case Color.GRAY : org.uqbar.arena.examples.apuestas.domain.Color.GRIS
		}
	}
	
}
