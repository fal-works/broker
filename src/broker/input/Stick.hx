package broker.input;

/**
	A virtual analog stick.
**/
@:using(broker.input.StickExtension)
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
	inline function setCartesian(x: Float, y: Float): Void {
		final sensitivity = this.sensitivity;
		syncPolar(this.x = sensitivity * x, this.y = sensitivity * y);
	}

	/**
		Updates all values of `this` according to `distance` and `angle`.
	**/
	inline function setPolar(distance: Float, angle: Float): Void {
		syncCartesian(this.sensitivity * distance, this.angle = angle);
	}

	/**
		Multiplies the displacement distance of `this` by `factor`.
	**/
	inline function multiplyDistance(factor: Float): Void {
		this.x *= factor;
		this.y *= factor;
		this.distance *= factor;
	}

	/**
		Resets all values of `this` (including `sensitivity`).
	**/
	inline function reset(): Void {
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
