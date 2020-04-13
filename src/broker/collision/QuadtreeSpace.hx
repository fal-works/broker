package broker.collision;

import banker.common.MathTools.maxInt;
import banker.vector.Vector;
import broker.collision.QuadtreeSpaceTools.*;

using banker.type_extension.FloatExtension;

/**
	A linear quadtree representing space partitioning.
**/
#if !broker_generic_disable
@:generic
#end
class QuadtreeSpace<T> {
	/**
		List of all `Cell`s in all levels.
	**/
	public final cells: Vector<Cell<T>>;

	final width: Int;
	final height: Int;
	final maxLevel: Int;
	final nullCell: Cell.NullCell<T>;
	final leafCellPositionFactorX: Float;
	final leafCellPositionFactorY: Float;

	public function new(
		width: Int,
		height: Int,
		maxLevel: Int,
		defaultColliderValue: T
	) {
		final cellCount = getTotalCellCount(maxLevel);
		this.cells = Vector.createPopulated(
			cellCount,
			() -> new Cell(defaultColliderValue)
		);

		this.width = width;
		this.height = height;
		this.maxLevel = maxLevel;
		this.nullCell = new Cell.NullCell();

		final leafCellCount1D = Math.pow(2, maxLevel);
		this.leafCellPositionFactorX = leafCellCount1D / width;
		this.leafCellPositionFactorY = leafCellCount1D / height;
	}

	/**
		Clears all `Cell`s in `this` quadtree.
	**/
	public function clear() {
		final cells = this.cells;
		final len = cells.length;
		var i = 0;
		while (i < len) {
			cells[i].clear();
			++i;
		}
	}

	/**
		Get the `Cell` instance that corresponds to given bounds.
	**/
	public inline function getCellFromBounds(
		leftX: Float,
		topY: Float,
		rightX: Float,
		bottomY: Float
	): Cell.AbstractCell<T> {
		final leftTopMortonNumber = getMortonNumber(leftX, topY);
		final rightBottomMortonNumber = getMortonNumber(rightX, bottomY);

		return if (leftTopMortonNumber == -1 && rightBottomMortonNumber == -1) {
			this.nullCell;
		} else {
			final maxLevel = this.maxLevel;
			var level: Int;
			var localCellIndex: Int;

			if (leftTopMortonNumber == rightBottomMortonNumber) {
				level = maxLevel;
				localCellIndex = leftTopMortonNumber;
			} else {
				level = getBelongingLevel(leftTopMortonNumber, rightBottomMortonNumber, maxLevel);
				final largerMorton = maxInt(
					leftTopMortonNumber,
					rightBottomMortonNumber
				); // For avoiding `-1`
				localCellIndex = getLocalCellIndex(largerMorton, level, maxLevel);
			}

			this.getCell(level, localCellIndex);
		}
	}

	/**
		Gets the specified `Cell` instance.
		Also activates all ancestor `Cell`s including the `Cell` to be returned.
	**/
	inline function getCell(level: Int, localCellIndex: Int): Cell<T> {
		final globalCellIndex = getGlobalCellIndex(level, localCellIndex);
		final cells = this.cells;
		activateAncestorCells(cells, globalCellIndex);

		return cells[globalCellIndex];
	}

	inline function getMortonNumber(x: Float, y: Float): Int {
		return if (x < 0 || x > this.width || y < 0 || y > this.height) {
			-1;
		} else {
			final cellPositionX: Int = (x * this.leafCellPositionFactorX).toInt();
			final cellPositionY: Int = (y * this.leafCellPositionFactorY).toInt();

			zipBits(cellPositionX, cellPositionY);
		}
	}
}
