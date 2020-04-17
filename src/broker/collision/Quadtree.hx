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
	public var cellCount(get, never): Int;

	@:access(banker.vector.WritableVector)
	public function new(partitionLevel: PartitionLevel) {
		final length = partitionLevel.totalCellCount();
		final data = new WritableVector(length);

		var currentLevel = new PartitionLevel(0);
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
		return this[index.toInt()];

	/**
		@return The root `Cell`.
	**/
	public extern inline function root(): Cell
		return this[0];

	/**
		Clears each `Cell` in `this`.
	**/
	public inline function reset(): Void {
		final len = this.length;
		var i = 0;
		while (i < len) {
			this[i].clear();
			++i;
		}
	}

	/**
		Activates the `Cell` at `index` and all of its ancestors, then adds `collider` to that `Cell`.
	**/
	public inline function loadAt(index: GlobalCellIndex, collider: Collider): Void
		activate(index).add(collider);

	/**
		Activates the `Cell` at `index` and all of its ancestors.
		@return The `Cell` at `index`.
	**/
	public inline function activate(index: GlobalCellIndex): Cell {
		final cell = this[index.toInt()];

		var currentIndex = index;
		var currentCell = cell;

		while (!currentCell.isActive) {
			currentCell.isActive = true;

			if (currentIndex.isZero()) break;
			currentIndex = currentIndex.parent();
			currentCell = this[currentIndex.toInt()];
		}

		return cell;
	}

	extern inline function get_cellCount()
		return this.length;
}
