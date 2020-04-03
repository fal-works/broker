package broker.input;

class StickExtension {
	/**
		Reflects the status of direction buttons to `this` stick.
		The stick displacement is normalized. `this.distance` is set to `this.sensitivity`
		if any direction button is pressed (otherwise it's set to `0.0`).
		@return `true` if any direction button is pressed.
	**/
	@:access(broker.input.Stick)
	public static function reflect(
		_this: Stick,
		left: ButtonStatus,
		up: ButtonStatus,
		right: ButtonStatus,
		down: ButtonStatus
	): Bool {
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
