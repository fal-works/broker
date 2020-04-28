package broker.geometry;

/**
	Set of coordinates representing a 2D AABB.
**/
@:structInit
class AxisAlignedBoundingBox implements ripper.Data {
	/**
		X coordinate of the left bound.
	**/
	public final leftX: Float;

	/**
		Y coordinate of the top bound.
	**/
	public final topY: Float;

	/**
		X coordinate of the right bound.
	**/
	public final rightX: Float;

	/**
		Y coordinate of the bottom bound.
	**/
	public final bottomY: Float;

	/**
		@return `true` if `this` region contains the given point `(x, y)`.
	**/
	public inline function containsPoint(x: Float, y: Float): Bool
		return y < bottomY && topY <= y && leftX <= x && x < rightX;
}
