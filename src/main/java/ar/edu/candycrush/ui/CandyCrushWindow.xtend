package ar.edu.candycrush.ui

import ar.edu.candycrush.domain.CandyCrushJuego
import org.uqbar.arena.actions.AsyncActionDecorator
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension ar.edu.candycrush.domain.Extensions.*
import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class CandyCrushWindow extends SimpleWindow<CandyCrushJuego> {

	new(WindowOwner owner, CandyCrushJuego juego) {
		super(owner, juego)
		title = "Candy Crush"
		taskDescription = "A explotar caramelos !"
		new AsyncActionDecorator[|Thread.sleep(1500) modelObject.crearTablero()].execute
	}

	override createFormPanel(Panel mainPanel) {
		new Panel(mainPanel) => [
			layout = new HorizontalLayout
			new Label(it).text = "Puntaje:"
			new Label(it) => [
				width = 30
				value <=> "jugador.puntos"
			]
		]
		this.crearTablero(mainPanel)
	}

	def crearTablero(Panel mainPanel) {
		val tableroPanel = new Panel(mainPanel) => []
		tableroPanel.layout = new ColumnLayout(modelObject.tablero.ancho)

		modelObject.tablero.celdas.forEach [ celda |
			new Panel(tableroPanel, celda) => [
				new Button(it) => [
					width = 40
					height = 40
//					bindBackgroundToTransformer("contenido.color",
//						[ c |
//							switch (c) {
//								case ar.edu.candycrush.domain.Color.AZUL: Color.BLUE
//								case ar.edu.candycrush.domain.Color.AMARILLO: Color.YELLOW
//								case ar.edu.candycrush.domain.Color.VERDE: Color.GREEN
//								case ar.edu.candycrush.domain.Color.ROJO: Color.RED
//								case ar.edu.candycrush.domain.Color.GRIS: Color.GRAY
//							}
//						])
					(background <=> "contenido.color").transformer = new CeldaColorTransformer 
					//caption = ""
					//	caption = celda.coordenadaAbsoluta.toString
					bindCaptionToProperty("seleccionada")
						.transformer = [m|if(m) "   X   " else "      "]
						.toViewTransformer(typeof(Boolean))
					onClick = new AsyncActionDecorator[|modelObject.seleccionarCaramelo(celda)]
				]
			]
		]
	}

	override addActions(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Jugar"
			setAsDefault
			disableOnError
		]

		new Label(actionsPanel) => [
			width = 150
		]
	}

}
