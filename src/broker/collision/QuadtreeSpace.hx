package broker.collision;

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
	public final cells: LinearCells<T>;

	final width: Int;
	final height: Int;
	final maxLevel: PartitionLevel;
	final nullCell: Cell.NullCell<T>;
	final leafCellPositionFactorX: Float;
	final leafCellPositionFactorY: Float;

	public function new(
		width: Int,
		height: Int,
		maxLevel: PartitionLevel,
		defaultColliderValue: T
	) {
		this.cells = new LinearCells(maxLevel, defaultColliderValue);

		this.width = width;
		this.height = height;
		this.maxLevel = maxLevel;
		this.nullCell = new Cell.NullCell();

		final gridSize = maxLevel.gridSize();
		this.leafCellPositionFactorX = gridSize / width;
		this.leafCellPositionFactorY = gridSize / height;
	}

	/**
		Clears all `Cell`s in `this` quadtree.
	**/
	public function clear(): Void {
		this.cells.reset();
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
		final leftTop = getLeafCellLocalIndex(leftX, topY);
		final rightBottom = getLeafCellLocalIndex(rightX, bottomY);

		return if (leftTop.isNone() && rightBottom.isNone()) {
			this.nullCell;
		} else {
			final maxLevel = this.maxLevel;
			var level: PartitionLevel;
			var localIndex: LocalCellIndex;

			if (leftTop == rightBottom) {
				level = maxLevel;
				localIndex = leftTop;
			} else {
				level = LocalCellIndex.getAabbLevel(leftTop, rightBottom, maxLevel);
				final largerMorton = LocalCellIndex.max(
					leftTop,
					rightBottom
				); // For avoiding `-1`
				localIndex = largerMorton.inRoughLevel(maxLevel, level);
			}

			this.getCell(level, localIndex);
		}
	}

	/**
		Gets the specified `Cell` instance.
		Also activates all ancestor `Cell`s including the `Cell` to be returned.
	**/
	inline function getCell(level: PartitionLevel, localIndex: LocalCellIndex): Cell<T> {
		final globalIndex = localIndex.toGlobal(level);
		return this.cells.activateCell(globalIndex);
	}

	/**
		@return The local index of the leaf `Cell` that contains the position `x, y`.
	**/
	inline function getLeafCellLocalIndex(x: Float, y: Float): LocalCellIndex {
		return if (x < 0 || x > this.width || y < 0 || y > this.height) {
			LocalCellIndex.none;
		} else {
			final cellPositionX: Int = (x * this.leafCellPositionFactorX).toInt();
			final cellPositionY: Int = (y * this.leafCellPositionFactorY).toInt();

			new LocalCellIndex(zipBits(cellPositionX, cellPositionY));
		}
	}
}
