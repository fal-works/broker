package broker.collision.cell;

import banker.vector.Vector;

/**
	List of all `Cell` instances in a quadtree space.
**/
@:forward(length)
abstract LinearCells(Vector<Cell>) {
	static final createCell = () -> new Cell();

	public extern inline function new(maxLevel: PartitionLevel) {
		this = Vector.createPopulated(
			maxLevel.totalCellCount(),
			createCell
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
