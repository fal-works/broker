package broker.geometry;

@:structInit
class MutablePoint extends Point {
	public function new(x: Float = 0.0, y: Float = 0.0) {
		super(x, y);
	}

	/**
		Sets coordinates of `this` point.
	**/
	public extern inline function set(x: Float, y: Float): MutablePoint {
		this._x = x;
		this._y = y;

		return this;
	}

	/**
		Sets X coordinate of `this` point.
	**/
	public extern inline function setX(v: Float): Float
		return this._x = v;

	/**
		Sets Y coordinate of `this` point.
	**/
	public extern inline function setY(v: Float): Float
		return this._y = v;
}
