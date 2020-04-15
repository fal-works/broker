package broker.collision;

import broker.collision.cell.*;

class CollisionDetector {
	public final space: CollisionSpace;
	public final cells: LinearCells;

	public function new(space: CollisionSpace) {
		this.space = space;
		this.cells = this.space.createCells();
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

		final space = this.space;
		final ancestorCellColliders = space.ancestorCellColliders;
		final searchStack = space.searchStack;

		var currentIndex: GlobalCellIndex;
		var currentCell: Cell;
		var currentLevel = 0;
		var searchStackSize = 0;
		var ancestorCellColliderCount = 0;

		inline function push(index: GlobalCellIndex): Void {
			searchStack[searchStackSize] = index;
			++searchStackSize;
		}
		inline function pop(): Void {
			--searchStackSize;
			currentIndex = searchStack[searchStackSize];
			currentCell = cells[currentIndex];

			final nextLevel = currentCell.level.toInt();
			if (nextLevel < currentLevel)
				ancestorCellColliderCount -= currentCell.colliderCount;

			currentLevel = nextLevel;
		}

		inline function pushAncestor(): Void {
			currentCell.exportTo(ancestorCellColliders, ancestorCellColliderCount);
			ancestorCellColliderCount += currentCell.colliderCount;
		}

		inline function detectInCell(cell: Cell): Void {
			cell.roundRobin(onOverlap);

			cell.detectCollisionWithVector(
				ancestorCellColliders,
				ancestorCellColliderCount,
				onOverlap
			);
		}

		push(GlobalCellIndex.zero);

		while (searchStackSize > 0) {
			pop();

			detectInCell(currentCell);

			var childCount = 0;
			for (childIndex in currentIndex.children(cells)) {
				if (cells[childIndex].isActive) {
					++childCount;
					push(childIndex);
				}
			}
			if (childCount > 0) pushAncestor();
		}
	}
}
