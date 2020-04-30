package broker.geometry;

@:structInit
class Point {
	var _x: Float;
	var _y: Float;

	public function new(x: Float, y: Float) {
		this._x = x;
		this._y = y;
	}

	/**
		@return X coordinate of `this` point.
	**/
	public extern inline function x(): Float
		return this._x;

	/**
		@return Y coordinate of `this` point.
	**/
	public extern inline function y(): Float
		return this._y;
}
