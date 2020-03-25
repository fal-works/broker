package broker.input.builtin.simple;

import broker.input.Stick;

class StickExtension {
	/**
		Reflects the status of direction buttons to `this` stick.
		The stick displacement is normalized. Assuming that the `sensitivity` is `1.0`,
		the distance is always `1.0` if any direction button is pressed (otherwise `0.0`).
		@return `true` if any direction button is pressed.
	**/
	@:access(broker.input.Stick)
	public static function reflect(_this: Stick, buttons: ButtonStatusMap): Bool {
		final left = buttons.LEFT;
		final up = buttons.UP;
		final right = buttons.RIGHT;
		final down = buttons.DOWN;

		final x = if (left.isPressed) {
			if (right.isPressed) {
				if (left.pressedFrameCount <= right.pressedFrameCount) -1.0; else 1.0;
			} else -1.0;
		} else if (right.isPressed) 1.0 else 0.0;

		final y = if (up.isPressed) {
			if (down.isPressed) {
				if (up.pressedFrameCount <= down.pressedFrameCount) -1.0; else 1.0;
			} else -1.0;
		} else if (down.isPressed) 1.0 else 0.0;

		if (x == 0.0 && y == 0.0) {
			_this.reset();
			return false;
		}

		final factor = if (x == 0 || y == 0) 1.0 else ONE_OVER_SQUARE_ROOT_TWO;
		_this.setCartesian(factor * x, factor * y);

		return true;
	}

	/** 1 / √2 **/
	static inline final ONE_OVER_SQUARE_ROOT_TWO = 0.7071067811865475;
}
