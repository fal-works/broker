package broker.collision;

import banker.vector.WritableVector;
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
		onOverlap: (colliderA: Collider, collierB: Collider) -> Void
	): Void {
		final cells = this.cells;
		final space = this.space;
		final colliderStack = space.colliderStack;
		final searchStack = space.searchStack;

		var currentIndex: GlobalCellIndex;
		var currentCell: Cell;
		var currentLevel = 0;
		var searchStackSize = 0;
		var colliderStackSize = 0;

		inline function pushCell(index: GlobalCellIndex): Void {
			searchStack[searchStackSize] = index;
			++searchStackSize;
		}
		inline function popCell(): Void {
			--searchStackSize;
			currentIndex = searchStack[searchStackSize];
			currentCell = cells[currentIndex];

			final nextLevel = currentCell.level.toInt();
			if (nextLevel < currentLevel)
				colliderStackSize -= currentCell.colliderCount;

			currentLevel = nextLevel;
		}

		inline function pushColliders(): Void {
			currentCell.exportTo(colliderStack, colliderStackSize);
			colliderStackSize += currentCell.colliderCount;
		}

		pushCell(GlobalCellIndex.zero);

		while (searchStackSize > 0) {
			popCell();

			this.detectInCell(
				currentCell,
				colliderStack,
				colliderStackSize,
				onOverlap
			);

			var hasChild = false;
			for (childIndex in currentIndex.children(cells)) {
				if (cells[childIndex].isActive) {
					hasChild = true;
					pushCell(childIndex);
				}
			}
			if (hasChild) pushColliders();
		}
	}

	inline function detectInCell(
		cell: Cell,
		colliderStack: WritableVector<Collider>,
		colliderStackSize: Int,
		onOverlap: (colliderA: Collider, collierB: Collider) -> Void
	): Void {
		cell.roundRobin(onOverlap);
		cell.detectCollisionWithVector(colliderStack, colliderStackSize, onOverlap);
	}
}
