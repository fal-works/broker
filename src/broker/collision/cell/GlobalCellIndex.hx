package broker.collision.cell;

/**
	Physical index of `Cell` in `Quadtree`.
**/
abstract GlobalCellIndex(Int) {
	extern public static inline final none = new GlobalCellIndex(-1);
	extern public static inline final zero = new GlobalCellIndex(0);

	@:op(A + B)
	extern public static function addInt(a: GlobalCellIndex, b: Int): GlobalCellIndex;

	extern public inline function new(v: Int)
		this = v;

	/**
		@return `true` if `this` is `GlobalCellIndex.none`.
	**/
	extern public inline function isNone(): Bool
		return this == GlobalCellIndex.none.int();

	/**
		@return `true` if `this` is a valid index.
	**/
	extern public inline function isSome(): Bool
		return this >= GlobalCellIndex.zero.int();

	/**
		Casts `this` to `Int`.
	**/
	extern public inline function int(): Int
		return this;

	/**
		Casts `this` to `UInt`.
	**/
	extern public inline function uint(): UInt
		return this;

	/**
		@return `true` if `this` is zero (the root cell index).
	**/
	extern public inline function isZero(): Bool
		return this == 0;

	/**
		@return The index of the parent cell.
	**/
	extern public inline function parent(): GlobalCellIndex {
		return new GlobalCellIndex((this - 1) >>> 2); // Std.int((this - 1) / 4)
	}

	/**
		@return Iterator for children indices of `this`.
	**/
	extern public inline function children(quadtree: Quadtree): IntIterator {
		final start = this * 4 + 1;
		final end = UInts.min(start + 4, quadtree.cellCount);
		return start...end;
	}
}
