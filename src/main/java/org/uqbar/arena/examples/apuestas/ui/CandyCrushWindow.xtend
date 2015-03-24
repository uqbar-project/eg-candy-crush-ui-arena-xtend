package org.uqbar.arena.examples.apuestas.ui

import org.uqbar.arena.actions.AsyncActionDecorator
import org.uqbar.arena.examples.apuestas.domain.CandyCrushJuego
import org.uqbar.arena.examples.apuestas.domain.Color
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.examples.apuestas.domain.Extensions.*

class CandyCrushWindow extends SimpleWindow<CandyCrushJuego> {

	new(WindowOwner owner, CandyCrushJuego juego) {
		super(owner, juego)
		title = "Candy Crush"
		taskDescription = "A explotar caramelos !"
		new AsyncActionDecorator[|Thread.sleep(1500); modelObject.crearTablero()].execute
	}

	override createFormPanel(Panel mainPanel) {
		new Panel(mainPanel) => [
			layout = new HorizontalLayout
			new Label(it).text = "Puntaje:"
			new Label(it) => [
				width = 30
				bindValueToProperty("jugador.puntos")
			]
		]
		this.crearTablero(mainPanel)
	}

	def crearTablero(Panel mainPanel) {
		val tableroPanel = new Panel(mainPanel)
		tableroPanel.setLayout(new ColumnLayout(modelObject.tablero.ancho))

		modelObject.tablero.celdas.forEach [ celda |
			new Panel(tableroPanel, celda) => [
				new Button(it) => [
					width = 40
					height = 40
//					bindBackgroudToTransformer("contenido.color",
//						[ c |
//							switch (c) {
//								case org.uqbar.arena.examples.apuestas.domain.Color.AZUL: Color.BLUE
//								case org.uqbar.arena.examples.apuestas.domain.Color.AMARILLO: Color.YELLOW
//								case org.uqbar.arena.examples.apuestas.domain.Color.VERDE: Color.GREEN
//								case org.uqbar.arena.examples.apuestas.domain.Color.ROJO: Color.RED
//								case org.uqbar.arena.examples.apuestas.domain.Color.GRIS: Color.GRAY
//							}
//						])
//					bindBackground("contenido.color").transformer = new CeldaColorTransformer 
					caption = ""
					//	caption = celda.coordenadaAbsoluta.toString
					bindCaptionToProperty("seleccionada").transformer = [m|if(m) "   X   " else "      "].
						toViewTransformer(typeof(Boolean))
					onClick = new AsyncActionDecorator[|modelObject.seleccionarCaramelo(celda)]
				]
			]
		]
	}

	override addActions(Panel actionsPanel) {
		val botonJugar = new Button(actionsPanel)
		botonJugar.setCaption("Jugar")
		botonJugar.setAsDefault
		botonJugar.disableOnError

		val labelResultado = new Label(actionsPanel)
		labelResultado.setWidth(150)
	}

}
