package broker.collision;

import banker.types.Bits;
import broker.collision.cell.*;

using banker.type_extension.FloatExtension;

/**
	Object that represents a 2D space with quadtree space partitioning.
**/
class CollisionSpace {
	/**
		@return The local index of the leaf `Cell` that contains the position `x, y`.
	**/
	static inline function getLeafCellLocalIndex(
		x: Float,
		y: Float,
		width: Int,
		height: Int,
		leafCellPositionFactorX: Float,
		leafCellPositionFactorY: Float
	): LocalCellIndex {
		return if (x < 0 || x >= width || y < 0 || y >= height) {
			LocalCellIndex.none;
		} else {
			final cellPositionX = (x * leafCellPositionFactorX).toInt();
			final cellPositionY = (y * leafCellPositionFactorY).toInt();

			final indexValue = Bits.zip(
				Bits.from(cellPositionX),
				Bits.from(cellPositionY)
			);

			new LocalCellIndex(indexValue.toInt());
		}
	}

	/**
		@see `new()`
	**/
	public final width: Int;

	/**
		@see `new()`
	**/
	public final height: Int;

	/**
		@see `new()`
	**/
	public final partitionLevel: PartitionLevel;

	/**
		The size of the space grid determined by `this.partitionLevel`.
	**/
	final gridSize: Int;

	/**
		Factor for calculating the position of a leaf cell
		(i.e. a cell in the finest partition level) in the space grid.
	**/
	final leafCellPositionFactorX: Float;

	/**
		Factor for calculating the position of a leaf cell
		(i.e. a cell in the finest partition level) in the space grid.
	**/
	final leafCellPositionFactorY: Float;

	/**
		@param width The width of the entire space (i.e. the width of root cell).
		@param height The height of the entire space (i.e. the height of root cell).
		@param partitionLevel The finest `PartitionLevel` value of `this` space (i.e. the depth of quadtrees).
	**/
	public function new(
		width: Int,
		height: Int,
		partitionLevel: Int
	) {
		this.width = width;
		this.height = height;
		this.partitionLevel = new PartitionLevel(partitionLevel);

		final gridSize = this.partitionLevel.gridSize();
		this.gridSize = gridSize;
		this.leafCellPositionFactorX = gridSize / width;
		this.leafCellPositionFactorY = gridSize / height;
	}

	public inline function createCells(): LinearCells {
		return new LinearCells(this.partitionLevel);
	}

	/**
		@return `GlobalCellIndex` of the finest `Cell` that contains the given AABB.
	**/
	public inline function getCellIndex(
		leftX: Float,
		topY: Float,
		rightX: Float,
		bottomY: Float
	): GlobalCellIndex {
		final width = this.width;
		final height = this.height;
		final leafCellPositionFactorX = this.leafCellPositionFactorX;
		final leafCellPositionFactorY = this.leafCellPositionFactorY;

		final leftTop = getLeafCellLocalIndex(
			leftX,
			topY,
			width,
			height,
			leafCellPositionFactorX,
			leafCellPositionFactorY
		);
		final rightBottom = getLeafCellLocalIndex(
			rightX,
			bottomY,
			width,
			height,
			leafCellPositionFactorX,
			leafCellPositionFactorY
		);

		return if (leftTop.isNone() && rightBottom.isNone()) {
			GlobalCellIndex.none;
		} else {
			final leafLevel = this.partitionLevel;
			var aabbLevel: PartitionLevel;
			var aabbLocalIndex: LocalCellIndex;

			if (leftTop == rightBottom) {
				aabbLevel = leafLevel;
				aabbLocalIndex = leftTop;
			} else {
				aabbLevel = LocalCellIndex.getAabbLevel(
					leftTop,
					rightBottom,
					leafLevel
				);
				final largerLeafCellIndex = LocalCellIndex.max(
					leftTop,
					rightBottom
				); // For avoiding `-1`
				aabbLocalIndex = largerLeafCellIndex.inRoughLevel(leafLevel, aabbLevel);
			}

			aabbLocalIndex.toGlobal(aabbLevel);
		}
	}
}
