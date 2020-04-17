package broker.collision.cell;

import banker.vector.Vector;
import banker.vector.WritableVector;

/**
	List of all `Cell` instances in a quadtree space.
**/
@:forward(length)
abstract LinearCells(Vector<Cell>) {
	@:access(banker.vector.WritableVector)
	public function new(maxLevel: PartitionLevel) {
		final length = maxLevel.totalCellCount();
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
}
