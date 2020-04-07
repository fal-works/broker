package broker.input.heaps;

import broker.input.interfaces.FullGamepad;
import broker.input.interfaces.ButtonStatusMapWithDpad as ButtonsWithDpad;

class HeapsPadPortExtension {
	/**
		Updates `stick` according to left analog stick values of the gamepad at `this` port.
	**/
	public static function updateStickFromLeftAnalog(
		_this: HeapsPadPort,
		stick: Stick
	): Void {
		final pad = _this.get();
		final config = pad.config;
		final padValues = pad.values;

		final x = padValues[config.analogX];
		final y = -padValues[config.analogY];
		stick.setCartesian(x, y);
	}

	/**
		Updates `stick` according to right analog stick values of the gamepad at `this` port.
	**/
	public static function updateStickFromRightAnalog(
		_this: HeapsPadPort,
		stick: Stick
	): Void {
		final pad = _this.get();
		final config = pad.config;
		final padValues = pad.values;

		final x = padValues[config.ranalogX];
		final y = -padValues[config.ranalogY];
		stick.setCartesian(x, y);
	}

	/**
		Updates trigger buttons of `gamepad` according to `this` values.
	**/
	public static inline function updateTriggers<B, M: ButtonsWithDpad<B>, S: Stick>(
		_this: HeapsPadPort,
		gamepad: FullGamepad<B, M, S>
	): Void {
		final pad = _this.get();
		final config = pad.config;
		final padValues = pad.values;

		gamepad.reflectTriggers(padValues[config.LT], padValues[config.RT]);
	}
}
