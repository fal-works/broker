package broker.collision;

import banker.vector.WritableVector;
import broker.collision.cell.*;

class CollisionDetector {
	/**
		Vector for using as a stack of `Cell` when traversing the quadtree.
	**/
	static var ancestorStack: WritableVector<Cell> = WritableVector.createZero();

	static var searchStack: WritableVector<GlobalCellIndex> = WritableVector.createZero();
	static var maxCellCount: Int = -1;

	public final space: CollisionSpace;
	public final cells: LinearCells;

	public function new(space: CollisionSpace) {
		this.space = space;
		this.cells = this.space.createCells();
		final cellCount = this.cells.length;

		if (cellCount > maxCellCount) {
			ancestorStack = new WritableVector(space.partitionLevel.toInt() + 1);
			searchStack = new WritableVector(cellCount);
		}
	}

	/**
		Registers `Collider`s by `loadQuadtree()` and then runs collision detection process
		for all registered `Collider`s.
	**/
	public function detect(
		loadQuadtree: (space: CollisionSpace, cells: LinearCells) -> Void,
		onOverlap: (colliderA: Collider, collierB: Collider) -> Void
	): Void {
		final ancestorStack = CollisionDetector.ancestorStack;
		final searchStack = CollisionDetector.searchStack;
		final cells = this.cells;

		cells.reset();
		loadQuadtree(this.space, cells);

		var currentIndex: GlobalCellIndex;
		var currentCell: Cell;
		var currentLevel: Int;
		var searchStackSize = 0;

		inline function push(index: GlobalCellIndex): Void {
			searchStack[searchStackSize] = index;
			++searchStackSize;
		}
		inline function pop(): Void {
			--searchStackSize;
			currentIndex = searchStack[searchStackSize];
			currentCell = cells[currentIndex];
			currentLevel = currentCell.level.toInt();
		}

		inline function pushAncestor(): Void {
			ancestorStack[currentLevel] = currentCell;
		}

		inline function detectInCell(cell: Cell): Void {
			cell.roundRobin(onOverlap);

			for (i in 0...currentLevel) {
				final otherCell = ancestorStack[i];
				cell.nestedLoopJoin(otherCell, onOverlap);
			}
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
