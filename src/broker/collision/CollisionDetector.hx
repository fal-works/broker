package broker.collision;

import sneaker.exception.NotOverriddenException;
import banker.vector.WritableVector;
import broker.collision.cell.*;

class CollisionDetector {
	public final space: CollisionSpace;
	public final leftCells: LinearCells;
	public final rightCells: LinearCells;

	final onOverlap: (colliderA: Collider, collierB: Collider) -> Void;

	function new(
		space: CollisionSpace,
		leftCells: LinearCells,
		rightCells: LinearCells,
		onOverlap: (colliderA: Collider, collierB: Collider) -> Void
	) {
		this.space = space;
		this.leftCells = leftCells;
		this.rightCells = rightCells;
		this.onOverlap = onOverlap;
	}

	/**
		Registers `Collider`s by `loadQuadtree()` and then runs collision detection process
		for all registered `Collider`s.
	**/
	public function detect(): Void {
		final space = this.space;
		final colliderStack = space.colliderStack;
		final searchStack = space.searchStack;

		final leftCells = this.leftCells;
		final onOverlap = this.onOverlap;

		var currentIndex: GlobalCellIndex;
		var currentLeftCell: Cell;
		var currentRightCell: Cell;
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
			currentLeftCell = leftCells[currentIndex];
			currentRightCell = rightCells[currentIndex];

			final nextLevel = currentLeftCell.level.toInt();
			if (nextLevel < currentLevel)
				colliderStackSize -= currentLeftCell.colliderCount;

			currentLevel = nextLevel;
		}

		inline function pushColliders(): Void {
			currentRightCell.exportTo(colliderStack, colliderStackSize);
			colliderStackSize += currentRightCell.colliderCount;
		}

		pushCell(GlobalCellIndex.zero);

		while (searchStackSize > 0) {
			popCell();

			this.detectInCell(
				currentLeftCell,
				colliderStack,
				colliderStackSize,
				onOverlap
			);

			var hasChild = false;
			for (childIndex in currentIndex.children(leftCells)) {
				if (leftCells[childIndex].isActive) {
					hasChild = true;
					pushCell(childIndex);
				}
			}
			if (hasChild) pushColliders();
		}
	}

	function detectInCell(
		cell: Cell,
		colliderStack: WritableVector<Collider>,
		colliderStackSize: Int,
		onOverlap: (colliderA: Collider, collierB: Collider) -> Void
	): Void {
		throw new NotOverriddenException();
	}
}

/**
	Object that performs round-robin collision detection within one single collider group.
**/
class IntraGroupCollisionDetector extends CollisionDetector {
	public function new(
		space: CollisionSpace,
		onOverlap: (colliderA: Collider, collierB: Collider) -> Void
	) {
		final cells = space.createCells();
		super(space, cells, cells, onOverlap);
	}

	override inline function detectInCell(
		leftCell: Cell,
		colliderStack: WritableVector<Collider>,
		colliderStackSize: Int,
		onOverlap: (colliderA: Collider, collierB: Collider) -> Void
	): Void {
		leftCell.roundRobin(onOverlap);
		leftCell.detectCollisionWithVector(
			colliderStack,
			colliderStackSize,
			onOverlap
		);
	}
}
