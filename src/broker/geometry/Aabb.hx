package broker.geometry;

/**
	Set of coordinates representing a 2D AABB.
**/
@:structInit
class Aabb {
	var _leftX: Float;
	var _topY: Float;
	var _rightX: Float;
	var _bottomY: Float;

	public function new(
		leftX: Float,
		topY: Float,
		rightX: Float,
		bottomY: Float
	) {
		this._leftX = leftX;
		this._topY = topY;
		this._rightX = rightX;
		this._bottomY = bottomY;
	}

	/**
		@return X coordinate of the left bound.
	**/
	public extern inline function leftX(): Float
		return this._leftX;

	/**
		@return Y coordinate of the top bound.
	**/
	public extern inline function topY(): Float
		return this._topY;

	/**
		@return X coordinate of the right bound.
	**/
	public extern inline function rightX(): Float
		return this._rightX;

	/**
		@return Y coordinate of the bottom bound.
	**/
	public extern inline function bottomY(): Float
		return this._bottomY;

	/**
		@return `true` if `this` region contains the given point `(x, y)`.
	**/
	public inline function containsPoint(x: Float, y: Float): Bool
		return y < _bottomY && _topY <= y && _leftX <= x && x < _rightX;

	/**
		@return `true` if `this` region overlaps a given AABB.
	**/
	public inline function overlapsAabb(
		otherLeftX: Float,
		otherTopY: Float,
		otherRightX: Float,
		otherBottomY: Float
	): Bool {
		return (otherTopY < this._bottomY)
			&& (this._topY < otherBottomY)
			&& (otherLeftX < this._rightX)
			&& (this._leftX < otherRightX);
	}
}
