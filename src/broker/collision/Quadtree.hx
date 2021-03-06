package broker.collision;

import banker.vector.Vector;
import banker.vector.WritableVector;
import broker.collision.cell.*;

/**
	Linear implementation of a quadtree of `Cell` instances.
**/
abstract Quadtree(Vector<Cell>) {
	/**
		The total number of `Cell`s in `this` quadtree.
	**/
	public var cellCount(get, never): UInt;

	@:access(banker.vector.WritableVector)
	public function new(partitionLevel: PartitionLevel) {
		final length = partitionLevel.totalCellCount();
		final data = new WritableVector(length);

		var currentLevel = new PartitionLevel(UInt.zero);
		var nextLevelIndex = currentLevel.totalCellCount();
		for (i in 0...length) {
			if (i >= nextLevelIndex) {
				++currentLevel;
				nextLevelIndex = currentLevel.totalCellCount();
			}
			data[i] = new Cell(currentLevel);
		}

		this = data.nonWritable();
	}

	@:op([]) extern inline function get(index: GlobalCellIndex): Cell
		return this[index.uint()];

	/**
		@return The root `Cell`.
	**/
	public extern inline function root(): Cell
		return this[UInt.zero];

	/**
		Clears each `Cell` in `this`.
	**/
	public inline function reset(): Void {
		final len = this.length;
		var i = UInt.zero;
		while (i < len) {
			this[i].clear();
			++i;
		}
	}

	/**
		Activates the `Cell` at `index` and all of its ancestors, then adds `collider` to that `Cell`.
		Be sure to not pass `GlobalCellIndex.none`.
	**/
	public inline function loadAt(index: GlobalCellIndex, collider: Collider): Void
		activate(index).add(collider);

	/**
		Activates the `Cell` at `index` and all of its ancestors.
		Be sure to not pass `GlobalCellIndex.none`.
		@return The `Cell` at `index`.
	**/
	public inline function activate(index: GlobalCellIndex): Cell {
		final cell = this[index.uint()];

		var currentIndex = index;
		var currentCell = cell;

		while (!currentCell.isActive) {
			currentCell.isActive = true;

			if (currentIndex.isZero()) break;
			currentIndex = currentIndex.parent();
			currentCell = this[currentIndex.int()];
		}

		return cell;
	}

	extern inline function get_cellCount()
		return this.length;
}
