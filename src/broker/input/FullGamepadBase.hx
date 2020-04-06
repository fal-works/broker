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
		@param buttons Mapping between buttons and their status.
		@param stick Any `Stick` object.
	**/
	function new(buttons: M, stick: S) {
		super(buttons, stick);
	}
}
