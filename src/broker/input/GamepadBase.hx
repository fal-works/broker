package broker.input;

import broker.input.interfaces.BasicGamepad;
import broker.input.interfaces.GenericButtonStatusMap;

/**
	Base class that implements `broker.input.interfaces.BasicGamepad`.
	Extend this class and override `update()` to implement updating procedure.
**/
#if !broker_generic_disable
@:generic
#end
class GamepadBase<B, M:GenericButtonStatusMap<B>, S:Stick>
	implements BasicGamepad<B, M, S> {
	public final buttons: M;
	public final stick: S;

	/**
		@param buttons Mapping between buttons and their status.
		@param stick Any `Stick` object.
	**/
	function new(buttons: M, stick: S) {
		this.buttons = buttons;
		this.stick = stick;
	}

	/**
		Updates status of `this` gamepad.
	**/
	public function update(): Void {}
}
