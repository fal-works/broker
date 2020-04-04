package broker.input.builtin.simple;

import broker.input.GamepadBase;
import broker.input.Stick;
import broker.input.builtin.simple.Button;
import broker.input.builtin.simple.ButtonStatusMap;

using broker.input.StickExtension;

/**
	A simple virtual gamepad using `broker.input.builtin.simple.Button`.
	`stick` automatically reflects the cross direction buttons.
**/
#if !broker_generic_disable
@:generic
#end
class Gamepad<S:Stick> extends GamepadBase<Button, ButtonStatusMap, S> {
	/**
		@param buttons Mapping between buttons and their status.
		@param stick Any `Stick` object.
	**/
	public function new(buttons: ButtonStatusMap, stick: S) {
		super(buttons, stick);
	}

	/**
		Updates status of all `buttons` and reflects them to `stick`.
	**/
	override public function update(): Void {
		super.update();
		this.updateStick();
	}

	/**
		Called in `update()`.
		Updates `this.stick` by reflecting the status of buttons.
		@return `true` if any direction button is pressed.
	**/
	@:access(broker.input.Stick)
	function updateStick(): Bool {
		final buttons = this.buttons;
		return this.stick.reflect(
			buttons.LEFT,
			buttons.UP,
			buttons.RIGHT,
			buttons.DOWN
		);
	}
}