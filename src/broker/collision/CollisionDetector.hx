package broker.collision;

import banker.vector.WritableVector;
import broker.collision.cell.*;

class CollisionDetector {
	public final space: CollisionSpace;
	public final cells: LinearCells;

	/**
		Vector for using as a stack of `Cell` when traversing the quadtree.
	**/
	final cellStack: WritableVector<Cell>;

	public function new(
		width: Int,
		height: Int,
		partitionLevelValue: Int
	) {
		final partitionLevel = new PartitionLevel(partitionLevelValue);
		this.space = new CollisionSpace(width, height, partitionLevel);
		this.cells = this.space.createCells();

		this.cellStack = new WritableVector(this.cells.length);
	}

	/**
		Registers `Collider`s by `loadQuadtree()` and then runs collision detection process
		for all registered `Collider`s.
	**/
	public function detect(
		loadQuadtree: (space: CollisionSpace, cells: LinearCells) -> Void,
		onOverlap: (colliderA: Collider, collierB: Collider) -> Void
	): Void {
		final cells = this.cells;
		cells.reset();
		loadQuadtree(this.space, cells);

		this.detectRecursive(
			cells,
			GlobalCellIndex.zero,
			this.cellStack,
			0,
			onOverlap
		);
	}

	function detectRecursive(
		cells: LinearCells,
		currentIndex: GlobalCellIndex,
		cellStack: WritableVector<Cell>,
		currentCellStackSize: Int,
		onOverlap: (colliderA: Collider, collierB: Collider) -> Void
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
		cell: Cell,
		cellStack: WritableVector<Cell>,
		currentCellStackSize: Int,
		onOverlap: (colliderA: Collider, collierB: Collider) -> Void
	): Void {
		cell.roundRobin(onOverlap);

		for (i in 0...currentCellStackSize) {
			final otherCell = cellStack[i];
			cell.nestedLoopJoin(otherCell, onOverlap);
		}
	}
}
