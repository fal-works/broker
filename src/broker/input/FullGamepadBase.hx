package broker.input;

import broker.input.interfaces.BasicGamepad;
import broker.input.interfaces.ButtonStatusMapWithDpad;

/**
	Base class that implements `broker.input.interfaces.FullGamepad`.
	Extend this class and override `update()` to implement updating procedure.
**/
#if !broker_generic_disable
@:generic
#end
class FullGamepadBase<B, M:ButtonStatusMapWithDpad<B>, S:Stick>
	extends GamepadBase<B, M, S>
	implements BasicGamepad<B, M, S> {
	/**
		A virtual right analog stick.
	**/
	final rightStick: S;

	/**
		Value of left trigger button.
	**/
	var leftTrigger: Float = 0;

	/**
		Value of right trigger button.
	**/
	var rightTrigger: Float = 0;

	/**
		Assigns values of left/right trigger buttons.
	**/
	public function reflectTriggers(leftValue: Float, rightValue: Float): Void {
		this.leftTrigger = leftValue;
		this.rightTrigger = rightValue;
	}

	/**
		@param buttons Mapping between buttons and their status.
		@param stick Any `Stick` object.
	**/
	function new(buttons: M, stick: S, rightStick: S) {
		super(buttons, stick);
		this.rightStick = rightStick;
	}
}
