package broker.collision;

import banker.common.MathTools.minInt;

/**
	The physical index of `Cell` in `LinearCells`.
**/
abstract GlobalCellIndex(Int) {
	extern public static inline final zero = new GlobalCellIndex(0);

	@:op(a + b)
	extern public static function subtractInt(a: GlobalCellIndex, b: Int): GlobalCellIndex;

	extern public inline function new(v: Int) {
		this = v;
	}

	/**
		Casts `this` to `Int`.
	**/
	extern public inline function toInt(): Int
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
	extern public inline function children<T>(
		cells: LinearCells<T>
	): GlobalCellIndexIterator {
		final start = this * 4 + 1;
		final end = minInt(start + 4, cells.length);
		return start...end;
	}
}

@:access(IntIterator)
abstract GlobalCellIndexIterator(IntIterator) from IntIterator {
	extern public inline function hasNext(): Bool {
		return this.min < this.max;
	}

	extern public inline function next(): GlobalCellIndex {
		return new GlobalCellIndex(this.min++);
	}
}