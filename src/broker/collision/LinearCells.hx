package broker.collision;

import banker.vector.Vector;

/**
	List of all `Cell` instances in a `QuadtreeSpace`.
**/
@:forward(length)
abstract LinearCells<T>(Vector<Cell<T>>) from Vector<Cell<T>> {
	extern public inline function new(maxLevel: PartitionLevel, defaultColliderValue: T) {
		this = Vector.createPopulated(
			maxLevel.totalCellCount(),
			() -> new Cell(defaultColliderValue)
		);
	}

	@:op([]) extern inline function get(index: GlobalCellIndex)
		return this[index.toInt()];

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
		Activates the `Cell` at `index` and all of its ancestors.
		@return The `Cell` at `index`.
	**/
	public inline function activateCell<T>(index: GlobalCellIndex): Cell<T> {
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
