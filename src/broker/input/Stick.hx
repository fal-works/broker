package broker.input;

/**
	A virtual analog stick.
**/
@:using(broker.input.Stick.StickExtension)
class Stick {
	static inline function hypotenuse(x: Float, y: Float)
		return Math.sqrt(x * x + y * y);

	/**
		The x component of displacement from origin.
	**/
	public var x(default, null): Float = 0;

	/**
		The y component of displacement from origin.
	**/
	public var y(default, null): Float = 0;

	/**
		The distance from origin to the position `x`, `y`.
	**/
	public var distance(default, null): Float = 0;

	/**
		The angle from origin to the position `x`, `y`.
	**/
	public var angle(default, null): Float = 0;

	/**
		The multiplying factor used in `setCartesian()` and `setPolar()`.
	**/
	public var sensitivity(default, null): Float = 1;

	public function new() {}

	/**
		Updates all values of `this` according to `x` and `y`.
	**/
	public inline function setCartesian(x: Float, y: Float): Void {
		final sensitivity = this.sensitivity;
		syncPolar(this.x = sensitivity * x, this.y = sensitivity * y);
	}

	/**
		Updates all values of `this` according to `distance` and `angle`.
	**/
	public inline function setPolar(distance: Float, angle: Float): Void {
		syncCartesian(
			this.distance = this.sensitivity * distance,
			this.angle = angle
		);
	}

	/**
		Sets the displacement distance of `this` to `value`.
	**/
	public inline function setDistance(value: Float): Void {
		this.setPolar(value, this.angle);
	}

	/**
		Multiplies the displacement distance of `this` by `factor`.
	**/
	public inline function multiplyDistance(factor: Float): Void {
		this.x *= factor;
		this.y *= factor;
		this.distance *= factor;
	}

	/**
		Resets all values of `this` (including `sensitivity`).
	**/
	public inline function reset(): Void {
		this.x = 0;
		this.y = 0;
		this.distance = 0;
		this.angle = 0;
		this.sensitivity = 1;
	}

	/**
		Internally used in `setCartesian()`.
	**/
	inline function syncPolar(x: Float, y: Float): Void {
		this.distance = hypotenuse(x, y);
		this.angle = Math.atan2(y, x);
	}

	/**
		Internally used in `setPolar()`.
	**/
	inline function syncCartesian(distance: Float, angle: Float): Void {
		this.x = distance * Math.cos(angle);
		this.y = distance * Math.sin(angle);
	}
}

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
