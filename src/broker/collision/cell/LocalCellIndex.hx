package broker.collision.cell;

/**
	Index of `Cell` in a specific `PartitionLevel` in Z-order.
**/
abstract LocalCellIndex(Int) {
	public static extern inline final none = new LocalCellIndex(-1);
	public static extern inline final zero = new LocalCellIndex(0);

	@:op(a ^ b)
	public static function xor(a: LocalCellIndex, b: LocalCellIndex): Int;

	/**
		@param level The level to which `leftTop` and `rightBottom` belong.
		@return The level to which the AABB should belong, i.e. the finest level
		which has a cell that contains both `leftTop` and `rightBottom` as its children cells.
	**/
	public static inline function getAabbLevel(
		leftTop: LocalCellIndex,
		rightBottom: LocalCellIndex,
		level: PartitionLevel
	): PartitionLevel {
		final xorBits = leftTop ^ rightBottom;

		var aabbLevel = level;
		var checkingLevel = aabbLevel;
		var shiftCount = 0;

		while (!checkingLevel.isZero()) {
			--checkingLevel;
			final twoBits = (xorBits >>> shiftCount) & 0x3;
			if (twoBits != 0) aabbLevel = checkingLevel;

			shiftCount += 2;
		}

		return aabbLevel;
	}

	/**
		@return The larger index.
	**/
	public extern static inline function max(
		a: LocalCellIndex,
		b: LocalCellIndex
	): LocalCellIndex {
		return if (a.int() < b.int()) b else a;
	}

	public extern inline function new(v: Int)
		this = v;

	/**
		Casts `this` to `Int`.
	**/
	public extern inline function int(): Int
		return this;

	/**
		@return `true` if `this == LocalCellIndex.none`.
	**/
	public extern inline function isNone(): Bool
		return this == -1;

	/**
		@param level The level to which `this` index belongs.
		@return `GlobalCellIndex` representation of `this`.
	**/
	public extern inline function toGlobal(level: PartitionLevel): GlobalCellIndex
		return level.firstGlobalCellIndex() + this;

	/**
		@param currentLevel The level `this` index belongs.
		@param roughLevel The target level. Should be rougher (i.e. lower value) than `currentLevel`.
		@return The local index in `roughLevel`.
	**/
	public extern inline function inRoughLevel(
		currentLevel: PartitionLevel,
		roughLevel: PartitionLevel
	): LocalCellIndex {
		final shift = ((currentLevel - roughLevel).int() * 2);
		return new LocalCellIndex(this >>> shift);
	}
}
