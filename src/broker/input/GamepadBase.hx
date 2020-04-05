package broker.input;

import broker.input.interfaces.Gamepad;
import broker.input.interfaces.GenericButtonStatusMap;

/**
	Base class that implements `broker.input.interfaces.Gamepad`.
**/
#if !broker_generic_disable
@:generic
#end
class GamepadBase<B, M:GenericButtonStatusMap<B>, S:Stick> implements Gamepad<B, M, S> {
	public final buttons: M;
	public final stick: S;

	/**
		@param buttons Mapping between buttons and their status.
		@param stick Any `Stick` object.
	**/
	public function new(buttons: M, stick: S) {
		this.buttons = buttons;
		this.stick = stick;
	}

	/**
		Updates status of all `buttons` and `stick`.
	**/
	public function update(): Void {
		this.buttons.forEachValue(ButtonStatus.updateCallback);
	}
}
