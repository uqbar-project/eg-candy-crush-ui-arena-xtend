package ar.edu.candycrush.ui

import java.awt.Color
import org.uqbar.arena.bindings.ValueTransformer

final class CeldaColorTransformer implements ValueTransformer<Object, Object> {

	override getModelType() {
		typeof(Object)
	}

	override getViewType() {
		typeof(Object)
	}

	override modelToView(Object valueModel) {
		val valueFromModel = valueModel as ar.edu.candycrush.domain.Color
		switch (valueFromModel) {
			case ar.edu.candycrush.domain.Color.AZUL: Color.BLUE
			case ar.edu.candycrush.domain.Color.AMARILLO: Color.YELLOW
			case ar.edu.candycrush.domain.Color.VERDE: Color.GREEN
			case ar.edu.candycrush.domain.Color.ROJO: Color.RED
			case ar.edu.candycrush.domain.Color.GRIS: Color.GRAY
		}
	}

	override viewToModel(Object valueView) {
		val valueFromView = valueView as Color
		switch (valueFromView) {
			case Color.BLUE : ar.edu.candycrush.domain.Color.AZUL
			case Color.YELLOW : ar.edu.candycrush.domain.Color.AMARILLO
			case Color.GREEN : ar.edu.candycrush.domain.Color.VERDE
			case Color.RED : ar.edu.candycrush.domain.Color.ROJO
			case Color.GRAY : ar.edu.candycrush.domain.Color.GRIS
		}
	}
	
}
