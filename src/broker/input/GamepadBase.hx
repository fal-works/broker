package broker.input;

import broker.input.interfaces.Gamepad;
import broker.input.interfaces.GenericButtonStatusMap;

/**
	Base class that implements `broker.input.interfaces.Gamepad`.
**/
#if !broker_generic_disable
@:generic
#end
class GamepadBase<B, M:GenericButtonStatusMap<B>> implements Gamepad<B, M> {
	public final buttons: M;
	public final stick: Stick;
	final updater: Gamepad<B, M> -> Void;

	/**
		@param buttons Mapping between buttons and their status.
		@param stick Any `Stick` object.
		@param updater Function to be run every time after updating `buttons` in `this.update()`.
	**/
	public function new(buttons: M, stick: Stick, updater: Gamepad<B, M> -> Void) {
		this.buttons = buttons;
		this.stick = stick;
		this.updater = updater;
	}

	/**
		Updates status of all `buttons` and `stick`.
	**/
	public function update(): Void {
		this.buttons.forEachValue(ButtonStatus.updateCallback);
		this.updater(this);
	}
}
