package broker.collision;

import banker.vector.WritableVector;
import broker.collision.cell.*;

#if !broker_generic_disable
@:generic
#end
class CollisionDetector<T> {
	/**
		An instance of linear quadtree space.
	**/
	public final quadtree: QuadtreeSpace<T>;

	/**
		Vector for using as a stack of `Cell` when traversing the quadtree.
	**/
	final cellStack: WritableVector<Cell<T>>;

	public function new(
		width: Int,
		height: Int,
		partitionLevelValue: Int,
		defaultColliderValue: T
	) {
		this.quadtree = new QuadtreeSpace(
			width,
			height,
			new PartitionLevel(partitionLevelValue),
			defaultColliderValue
		);
		this.cellStack = new WritableVector(this.quadtree.cells.length);
	}

	/**
		Registers `Collider`s by `loadQuadtree()` and then runs collision detection process
		for all registered `Collider`s.
	**/
	public function detect(
		loadQuadtree: (quadtree: QuadtreeSpace<T>) -> Void,
		onOverlap: (colliderA: Collider<T>, collierB: Collider<T>) -> Void
	): Void {
		final quadtree = this.quadtree;
		quadtree.clear();
		loadQuadtree(quadtree);

		this.detectRecursive(
			quadtree.cells,
			GlobalCellIndex.zero,
			cellStack,
			0,
			onOverlap
		);
	}

	function detectRecursive(
		cells: LinearCells<T>,
		currentIndex: GlobalCellIndex,
		cellStack: WritableVector<Cell<T>>,
		currentCellStackSize: Int,
		onOverlap: (colliderA: Collider<T>, collierB: Collider<T>) -> Void
	): Void {
		final currentCell = cells[currentIndex];
		if (currentCell == null) return;

		this.detectInCell(currentCell, cellStack, currentCellStackSize, onOverlap);

		// Detect in child cells recursively
		for (childIndex in currentIndex.children(cells)) {
			final childCell = cells[childIndex];
			if (childCell.isActive) {
				cellStack[currentCellStackSize] = currentCell;
				this.detectRecursive(
					cells,
					childIndex,
					cellStack,
					currentCellStackSize + 1,
					onOverlap
				);
			}
		}
	}

	/**
		1. Detects collision within `cell`.
		2. Detects collision between `cell` and each cell in `cellStack`.
	**/
	inline function detectInCell(
		cell: Cell<T>,
		cellStack: WritableVector<Cell<T>>,
		currentCellStackSize: Int,
		onOverlap: (colliderA: Collider<T>, collierB: Collider<T>) -> Void
	): Void {
		cell.roundRobin(onOverlap);

		for (i in 0...currentCellStackSize) {
			final otherCell = cellStack[i];
			cell.nestedLoopJoin(otherCell, onOverlap);
		}
	}
}
