package broker.input.builtin.simple;

import broker.input.Stick;
import broker.input.builtin.simple.Button;
import broker.input.builtin.simple.ButtonStatusMap;

/**
	An extended `Gamepad` (using `broker.input.builtin.simple.Button`)
	that is able to switch the moving speed (i.e. `this.stick.distance`)
	according to the status of a specific button provided when instantiating,
	thus suited for classic 2D shoot'em up games.
**/
#if !broker_generic_disable
@:generic
#end
class ShmupGamepad<S:Stick> extends Gamepad<S> {
	/** @see `new()` **/
	final defaultSpeed: Float;

	/** @see `new()` **/
	final alternativeSpeed: Float;

	/**
		Status of the speed change button.
	**/
	final speedChange: ButtonStatus;

	/**
		@param buttons Mapping between buttons and their status.
		@param stick Any `Stick` object.
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

	/**
		Called in `update()`.
		Updates `this.stick` by reflecting the status of
		cross direction buttons and the speed change button.
		@return `true` if any direction button is pressed.
	**/
	@:access(broker.input.Stick)
	override function updateStick(): Bool {
		final moving = super.updateStick();

		if (moving) {
			final speed = if (this.speedChange.isPressed)
				this.alternativeSpeed
			else
				this.defaultSpeed;

			this.stick.multiplyDistance(speed);
		}

		return moving;
	}
}
