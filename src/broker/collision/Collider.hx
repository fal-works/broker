package broker.collision;

import sneaker.types.Maybe;

using banker.type_extension.FloatExtension;

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
	public var leftX: Float;

	/**
		The y coordinate of the top bound.
	**/
	public var topY: Float;

	/**
		The x coordinate of the right bound.
	**/
	public var rightX: Float;

	/**
		The y coordinate of the bottom bound.
	**/
	public var bottomY: Float;

	/**
		Used for linking another `Collider` and constructing a linked list.
	**/
	public var next: Maybe<Collider>;

	public function new(id: Int) {
		this.id = id;
		this.leftX = Math.NEGATIVE_INFINITY;
		this.topY = Math.NEGATIVE_INFINITY;
		this.rightX = Math.NEGATIVE_INFINITY;
		this.bottomY = Math.NEGATIVE_INFINITY;
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
		leftX: Float,
		topY: Float,
		rightX: Float,
		bottomY: Float
	): Void {
		this.leftX = leftX;
		this.topY = topY;
		this.rightX = rightX;
		this.bottomY = bottomY;
	}

	/**
		Sets the id and bounds of `this`.
	**/
	public inline function set(
		id: Int,
		leftX: Float,
		topY: Float,
		rightX: Float,
		bottomY: Float
	): Void {
		this.id = id;
		this.setBounds(leftX, topY, rightX, bottomY);
	}

	/**
		@return `true` if `this` overlaps `other`.
	**/
	public extern inline function overlaps(other: Collider): Bool {
		return (other.topY < this.bottomY) && (this.topY < other.bottomY) && (other.leftX < this.rightX) && (this.leftX < other.rightX);
	}

	/**
		@return `String` representation of `this`.
	**/
	public inline function toString(): String {
		return
			'{ id: $id, p1: (${leftX.toInt()}, ${topY.toInt()}), p2: (${rightX.toInt()}, ${bottomY.toInt()}) }';
	}
}
