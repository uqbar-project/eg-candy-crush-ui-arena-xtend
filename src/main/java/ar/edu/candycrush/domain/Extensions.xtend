package ar.edu.candycrush.domain

import java.util.Collection
import java.util.Random
import org.uqbar.arena.bindings.ValueTransformer
import org.uqbar.arena.bindings.transformers.AbstractReadOnlyTransformer

class Extensions {
	
	def static Integer random(IntegerRange range) {
		return new Random().nextInt(range.last - range.head) + range.head
	}	 
	
	def static <E> E random(Collection<E> col) {
		val index = (0..(col.size)).random
		col.get(index)
	}
	
	def static <M> ValueTransformer<M, String> toViewTransformer((M)=> String adapterFunction, Class<M> typeofModel) {
		new FunctionBasedTransformer(adapterFunction, typeofModel)
	}
	
}

class FunctionBasedTransformer<M> extends AbstractReadOnlyTransformer<M,String> {
	(M) => String toView = [ ]
	Class<M> typeOfModel
	
	new((M) => String toView, Class<M> typeOfModel) {
		this.toView = toView
		this.typeOfModel = typeOfModel
	}
	
	override getModelType() {
		typeOfModel
	}
	
	override getViewType() {
		typeof(String)
	}
	
	override modelToView(M valueFromModel) {
		toView.apply(valueFromModel)
	}
	
}