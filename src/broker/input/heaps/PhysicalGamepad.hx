package broker.input.heaps;

import banker.vector.VectorReference;
import broker.input.interfaces.FullGamepad;
import broker.input.interfaces.ButtonStatusMapWithDpad as ButtonsWithDpad;

/**
	An object that represents a physical gamepad.
**/
abstract PhysicalGamepad(hxd.Pad) from hxd.Pad to hxd.Pad {
	/**
		Null object for `PhysicalGamepad`.
	**/
	public static final NULL: PhysicalGamepad = hxd.Pad.createDummy();

	/**
		@return `true` if the button of `buttonCode` is down.
	**/
	public function isDown(buttonCode: ButtonCode): Bool
		return this.buttons[buttonCode.code];

	/**
		Sets a callback function that is called when `this` gamepad is disconnected.
	**/
	public function setOnDisconnect(callback: () -> Void): Void
		this.onDisconnect = callback;

	/**
		@return `true` if any button in `buttonCodes` is down.
	**/
	public function anyButtonIsDown(buttonCodes: VectorReference<ButtonCode>): Bool {
		final buttons = this.buttons;
		for (i in 0...buttonCodes.length) {
			if (buttons[buttonCodes[i].code]) return true;
		}
		return false;
	}

	/**
		Updates `stick` according to the main (= likely the left) analog stick values
		of the gamepad at `this` port.
	**/
	public function updateStick(stick: Stick): Void
		stick.setCartesian(this.xAxis, this.yAxis);

	/**
		Updates `stick` according to left analog stick values of the gamepad at `this` port.
	**/
	public function updateStickFromLeftAnalog(stick: Stick): Void {
		final config = this.config;
		final padValues = this.values;

		stick.setCartesian(padValues[config.analogX], -padValues[config.analogY]);
	}

	/**
		Updates `stick` according to right analog stick values of the gamepad at `this` port.
	**/
	public function updateStickFromRightAnalog(stick: Stick): Void {
		final config = this.config;
		final padValues = this.values;

		stick.setCartesian(padValues[config.ranalogX], -padValues[config.ranalogY]);
	}

	/**
		Updates `leftStick` and `rightStick` according to left/right analog sticks
		of the gamepad at `this` port.
	**/
	public function updateSticks(leftStick: Stick, rightStick: Stick): Void {
		final config = this.config;
		final padValues = this.values;

		leftStick.setCartesian(
			padValues[config.analogX],
			-padValues[config.analogY]
		);

		rightStick.setCartesian(
			padValues[config.ranalogX],
			-padValues[config.ranalogY]
		);
	}

	/**
		Updates trigger buttons of `gamepad` according to `this` values.
	**/
	public function updateTriggers<B, M: ButtonsWithDpad<B>, S: Stick>(
		gamepad: FullGamepad<B, M, S>
	): Void {
		final config = this.config;
		final padValues = this.values;

		gamepad.reflectTriggers(padValues[config.LT], padValues[config.RT]);
	}
}
