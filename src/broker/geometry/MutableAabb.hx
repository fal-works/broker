package broker.geometry;

/**
	Set of coordinates representing a 2D AABB.
**/
@:structInit
class MutableAabb extends Aabb {
	public function new(
		leftX: Float = 0.0,
		topY: Float = 0.0,
		rightX: Float = 0.0,
		bottomY: Float = 0.0
	) {
		super(leftX, topY, rightX, bottomY);
	}

	/**
		Sets coordinates of the bounds.
		@return `this`.
	**/
	public extern inline function set(
		leftX: Float,
		topY: Float,
		rightX: Float,
		bottomY: Float
	): MutableAabb {
		this._leftX = leftX;
		this._topY = topY;
		this._rightX = rightX;
		this._bottomY = bottomY;

		return this;
	}

	/**
		Sets X coordinate of the left bound.
	**/
	public extern inline function setLeftX(v: Float): Float
		return this._leftX = v;

	/**
		Sets Y coordinate of the top bound.
	**/
	public extern inline function setTopY(v: Float): Float
		return this._topY = v;

	/**
		Sets X coordinate of the right bound.
	**/
	public extern inline function setRightX(v: Float): Float
		return this._rightX = v;

	/**
		Sets Y coordinate of the bottom bound.
	**/
	public extern inline function setBottomY(v: Float): Float
		return this._bottomY = v;
}
