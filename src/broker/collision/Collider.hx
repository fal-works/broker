package broker.collision;

import sneaker.types.Maybe;

/**
	Unit data of any collidable object that can be registered to `Cell`.
**/
class Collider {
	/**
		The identifier number of `this`.
	**/
	public var id: Int;

	/**
		The x coordinate of the left bound.
	**/
	public var left: Float;

	/**
		The y coordinate of the top bound.
	**/
	public var top: Float;

	/**
		The x coordinate of the right bound.
	**/
	public var right: Float;

	/**
		The y coordinate of the bottom bound.
	**/
	public var bottom: Float;

	/**
		Used for linking another `Collider` and constructing a linked list.
	**/
	public var next: Maybe<Collider>;

	public function new(id: Int) {
		this.id = id;
		this.left = Math.NEGATIVE_INFINITY;
		this.top = Math.NEGATIVE_INFINITY;
		this.right = Math.NEGATIVE_INFINITY;
		this.bottom = Math.NEGATIVE_INFINITY;
		this.next = Maybe.none();
	}

	/**
		Clears `this.next`.
	**/
	public extern inline function unlink()
		this.next = Maybe.none();

	/**
		Sets bounds of `this`.
	**/
	public extern inline function setBounds(
		left: Float,
		top: Float,
		right: Float,
		bottom: Float
	): Void {
		this.left = left;
		this.top = top;
		this.right = right;
		this.bottom = bottom;
	}

	/**
		Sets the id and bounds of `this`.
	**/
	public inline function set(
		id: Int,
		left: Float,
		top: Float,
		right: Float,
		bottom: Float
	): Void {
		this.id = id;
		this.setBounds(left, top, right, bottom);
	}

	/**
		@return `true` if `this` overlaps `other`.
	**/
	public extern inline function overlaps(other: Collider): Bool {
		return (other.top < this.bottom) && (this.top < other.bottom) && (other.left < this.right) && (this.left < other.right);
	}
}
