package broker.collision;

import sneaker.assertion.Asserter.assert;
import banker.vector.Vector;

class QuadtreeSpaceTools {
	/**
		Converts local cell index to global cell index.
	**/
	public static inline function getGlobalCellIndex(level: Int, localCellIndex: Int): Int
		return getGlobalCellIndexOffset(level) + localCellIndex;

	/**
		Activates the `Cell` at `globalCellIndex` and all of its ancestors.
	**/
	public static inline function activateAncestorCells<T>(
		cells: Vector<Cell<T>>,
		globalCellIndex: Int
	): Void {
		var parentCellIndex = globalCellIndex;
		var parentCell = cells[parentCellIndex];

		while (!parentCell.isActive) {
			parentCell.isActive = true;

			if (parentCellIndex == 0) break;
			parentCellIndex = (parentCellIndex - 1) >>> 2; // Std.int((parentCellIndex - 1) / 4)
			parentCell = cells[parentCellIndex];
		}
	}

	/**
		Separates each bit of `n` with one unset bit.
		@param n Any bit array (max 16 bits)
	**/
	public static inline function separateBits(n: Int): Int {
		n = (n | (n << 8)) & 0x00ff00ff; // 0000 0000 1111 1111 0000 0000 1111 1111
		n = (n | (n << 4)) & 0x0f0f0f0f; // 0000 1111 0000 1111 0000 1111 0000 1111
		n = (n | (n << 2)) & 0x33333333; // 0011 0011 0011 0011 0011 0011 0011 0011
		n = (n | (n << 1)) & 0x55555555; // 0101 0101 0101 0101 0101 0101 0101 0101
		return n;
	}

	/**
		Zips two bit arrays.
		@param a Any bit array (max 16 bits)
		@param b Any bit array (max 16 bits)
	**/
	public static inline function zipBits(a: Int, b: Int): Int {
		return separateBits(a) | (separateBits(b) << 1);
	}

	/**
		@return The level to which a given AABB belongs.
	**/
	public static inline function getBelongingLevel(
		leftTopMortonNumber: Int,
		rightBottomMortonNumber: Int,
		maxLevel: Int
	): Int {
		final xorMorton = leftTopMortonNumber ^ rightBottomMortonNumber;
		var belongingLevel = maxLevel;
		var checkingLevel = belongingLevel - 1;

		var i = 0;
		while (checkingLevel >= 0) {
			final twoBits = (xorMorton >>> (i * 2)) & 0x3;
			if (twoBits > 0) belongingLevel = checkingLevel;

			++i;
			--checkingLevel;
		}

		return belongingLevel;
	}

	/**
		@return The local cell index in `level` that corresponds to `mortonNumber`.
	**/
	public static inline function getLocalCellIndex(
		mortonNumber: Int,
		level: Int,
		maxLevel: Int
	): Int {
		final shift = ((maxLevel - level) * 2);
		return mortonNumber >>> shift;
	}

	/**
		@return The total number of `Cell`s that a quadtree with `maxLevel` should contain.
	**/
	public static inline function getTotalCellCount(maxLevel: Int): Int
		return getGlobalCellIndexOffset(maxLevel + 1);

	/**
		@return The global index (i.e. the index in `QuadtreeSpace.cells`) of the first `Cell` in `level`.
	**/
	static inline function getGlobalCellIndexOffset(level: Int): Int {
		assert(level < 10);

		// Std.int((Math.pow(4, level) - 1) / 3)

		return switch level {
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
			default: 0;
		}
	}
}
