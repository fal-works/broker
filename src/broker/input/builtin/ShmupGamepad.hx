package broker.input.builtin;

import broker.input.Gamepad;
import broker.input.Stick;
import broker.input.builtin.simple.Button;
import broker.input.builtin.simple.ButtonStatusMap;

using broker.input.builtin.simple.StickExtension;

/**
	An extended `Gamepad` suited for general/classic 2D shoot'em up games.
**/
#if !broker_generic_disable
@:generic
#end
class ShmupGamepad<S: Stick> extends Gamepad<Button, ButtonStatusMap, S> {
	/** @see `new()` **/
	final defaultSpeed: Float;

	/** @see `new()` **/
	final alternativeSpeed: Float;

	/**
		Status of the speed change button.
	**/
	final speedChange: ButtonStatus;

	/**
		@param speedChangeButton The button for changing the moving speed.
		@param defaultSpeed Used when the speed changing button is not pressed.
		@param alternativeSpeed Used when the speed changing button is pressed.
	**/
	public function new(
		buttons: ButtonStatusMap,
		stick: S,
		speedChangeButton: Button,
		defaultSpeed: Float,
		alternativeSpeed: Float
	) {
		super(buttons, stick);

		this.speedChange = buttons.get(speedChangeButton);
		this.defaultSpeed = defaultSpeed;
		this.alternativeSpeed = alternativeSpeed;
	}

	override public function update(): Void {
		super.update();
		this.updateStick();
	}

	/**
		Called in `update()`.
		Updates `this.stick` by reflecting the status of buttons.
	**/
	@:access(broker.input.Stick)
	function updateStick() {
		final stick = this.stick;
		final buttons = this.buttons;

		final moving = stick.reflect(buttons);

		if (moving) {
			final speed = if (this.speedChange.isPressed) this.alternativeSpeed else this.defaultSpeed;
			stick.multiplyDistance(speed);
		}
	}
}
