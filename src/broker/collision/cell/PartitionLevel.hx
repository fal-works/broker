package broker.collision.cell;

/**
	The depth level in quadtree space partitioning.
**/
abstract PartitionLevel(Int) {
	@:op(A - B)
	public static function subtract(a: PartitionLevel, b: PartitionLevel): PartitionLevel;

	@:op(A - B)
	public static function subtractInt(a: PartitionLevel, b: Int): PartitionLevel;

	@:op(--A)
	public function preDecrement(): PartitionLevel;

	@:op(++A)
	public function preIncrement(): PartitionLevel;

	/**
		@param levelValue `0` is the root-cell level. More greater, more deeper and finer.
	**/
	public extern inline function new(levelValue: UInt) {
		this = levelValue;
	}

	/**
		@return `true` if `this` is zero (the roughest, root-cell level).
	**/
	public extern inline function isZero(): Bool
		return this == 0;

	/**
		Casts `this` to `Int`.
	**/
	public extern inline function int(): Int
		return this;

	/**
		Casts `this` to `Int`.
	**/
	@:access(sinker.UInt)
	public extern inline function uint(): UInt
		return new UInt(this);

	/**
		@return The size of the grid in `this` level. Same as `2 ^ (level value)`.
	**/
	public extern inline function gridSize(): UInt
		return UInts.powerOf2(this);

	/**
		@return The global cell index of the first `Cell` in `this` level.
	**/
	public extern inline function firstGlobalCellIndex(): GlobalCellIndex {
		return new GlobalCellIndex(switch this {
			case 0: 0;
			case 1: 1;
			case 2: 5;
			case 3: 21;
			case 4: 85;
			case 5: 341;
			case 6: 1365;
			case 7: 5461;
			case 8: 21845;
			case 9: 87381;
			default: Std.int((Math.pow(4, this) - 1) / 3);
		});
	}

	/**
		@return The total number of `Cell`s that a quadtree with `maxLevel` should contain.
	**/
	public extern inline function totalCellCount(): UInt {
		return new PartitionLevel(this + 1).firstGlobalCellIndex().uint();
	}
}
