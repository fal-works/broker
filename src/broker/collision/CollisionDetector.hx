package broker.collision;

import sneaker.exception.Exception;
import sneaker.exception.NotOverriddenException;
import banker.vector.WritableVector;
import broker.collision.cell.*;

class CollisionDetector {
	/**
		Shared vector for using as a stack storing left group `Collider`s in ancestor `Cell`s
		when traversing a quadtree.
		Not used by `IntraGroupCollisionDetector`.
	**/
	static var leftColliderStack: WritableVector<Collider> = WritableVector.createZero();

	/**
		Shared vector for storing the number of left group `Collider`s in each `Cell`.
		Not used by `IntraGroupCollisionDetector`.
	**/
	static var leftColliderCountStack: WritableVector<Int> = WritableVector.createZero();

	/**
		Shared vector for using as a stack storing right group `Collider`s in ancestor `Cell`s
		when traversing a quadtree.
	**/
	static var rightColliderStack: WritableVector<Collider> = WritableVector.createZero();

	/**
		Shared vector for storing the number of right group `Collider`s in each `Cell`.
	**/
	static var rightColliderCountStack: WritableVector<Int> = WritableVector.createZero();

	/**
		Shared vector for using as a stack for depth-first search in quadtree.
	**/
	static var childCellCountStack: WritableVector<Int> = WritableVector.createZero();

	/**
		Shared vector for using as a stack for depth-first search in quadtree.
	**/
	static var searchStack: WritableVector<GlobalCellIndex> = WritableVector.createZero();

	/**
		Creates a collision detector for round-robin detection within one collider group.
		@param quadtree Any `Quadtree` with the same level as `partitionLevel`.
		If not provided, creates a new one.
	**/
	public static function createIntraGroup(
		partitionLevel: PartitionLevel,
		maxColliderCount: Int,
		?quadtree: Quadtree
	): IntraGroupCollisionDetector {
		return new IntraGroupCollisionDetector(
			partitionLevel,
			maxColliderCount,
			quadtree
		);
	}

	/**
		Creates a collision detector for nested-loop detection between two collider groups.
		@param groups.left.quadtree
		Any `Quadtree` with the same level as `partitionLevel`.
		If not given, creates a new one.
		@param groups.right.quadtree ditto
	**/
	public static function createInterGroup(
		partitionLevel: PartitionLevel,
		groups: {
			left: { maxColliderCount: Int, ?quadtree: Quadtree },
			right: { maxColliderCount: Int, ?quadtree: Quadtree }
		}
	): InterGroupCollisionDetector {
		return new InterGroupCollisionDetector(
			partitionLevel,
			groups.left.maxColliderCount,
			groups.right.maxColliderCount,
			groups.left.quadtree,
			groups.right.quadtree
		);
	}

	/**
		The `Quadtree` for loading colliders in the "left" group.
	**/
	public final leftQuadtree: Quadtree;

	/**
		The `Quadtree` for loading colliders in the "right" group.
	**/
	public final rightQuadtree: Quadtree;

	function new(
		leftQuadtree: Quadtree,
		rightQuadtree: Quadtree,
		leftColliderStackCapacity: Int,
		rightColliderStackCapacity: Int,
		partitionLevel: PartitionLevel
	) {
		this.leftQuadtree = leftQuadtree;
		this.rightQuadtree = rightQuadtree;

		if (leftColliderStack.length < leftColliderStackCapacity)
			leftColliderStack = new WritableVector(leftColliderStackCapacity);

		if (rightColliderStack.length < rightColliderStackCapacity)
			rightColliderStack = new WritableVector(rightColliderStackCapacity);

		final level = partitionLevel.toInt();
		final levelPlusOne = level + 1;

		if (childCellCountStack.length < levelPlusOne)
			childCellCountStack = new WritableVector(levelPlusOne);

		if (leftColliderCountStack.length < levelPlusOne)
			leftColliderCountStack = new WritableVector(levelPlusOne);

		if (rightColliderCountStack.length < levelPlusOne)
			rightColliderCountStack = new WritableVector(levelPlusOne);

		final searchStackSize = Std.int(Math.pow(4, level));
		if (searchStack.length < searchStackSize)
			searchStack = new WritableVector(searchStackSize);
	}

	/**
		Runs collision detection process for all `Collider`s.
		Be sure to load `Collider`s to the cells before calling this method.
	**/
	public function detect(
		onOverlap: (collierA: Collider, colliderB: Collider) -> Void
	): Void {
		final leftColliderStack = CollisionDetector.leftColliderStack;
		final rightColliderStack = CollisionDetector.rightColliderStack;
		final leftColliderCountStack = CollisionDetector.leftColliderCountStack;
		final rightColliderCountStack = CollisionDetector.rightColliderCountStack;
		final childCellCountStack = CollisionDetector.childCellCountStack;
		final searchStack = CollisionDetector.searchStack;

		final leftQuadtree = this.leftQuadtree;
		final rightQuadtree = this.rightQuadtree;

		var currentIndex: GlobalCellIndex;
		var currentLeftCell: Cell;
		var currentRightCell: Cell;
		var currentLevel = 0;
		var searchStackSize = 0;
		var leftColliderStackSize = 0;
		var rightColliderStackSize = 0;

		inline function pushCell(index: GlobalCellIndex): Void {
			searchStack[searchStackSize] = index;
			++searchStackSize;
		}
		inline function popCell(): Void {
			--searchStackSize;
			currentIndex = searchStack[searchStackSize];
			currentLeftCell = leftQuadtree[currentIndex];
			currentRightCell = rightQuadtree[currentIndex];
			currentLevel = currentLeftCell.level.toInt();
		}

		inline function pushColliders(childCount: Int): Void {
			final nextLevel = currentLevel + 1;
			childCellCountStack[nextLevel] = childCount;

			final leftColliderCount = this.pushLeftColliders(
				currentLeftCell,
				leftColliderStack,
				leftColliderStackSize
			);
			leftColliderStackSize += leftColliderCount;
			leftColliderCountStack[nextLevel] = leftColliderCount;

			final rightColliderCount = this.pushRightColliders(
				currentRightCell,
				rightColliderStack,
				rightColliderStackSize
			);
			rightColliderStackSize += rightColliderCount;
			rightColliderCountStack[nextLevel] = rightColliderCount;
		}
		inline function countDown(): Void {
			final nextCount = childCellCountStack[currentLevel] - 1;
			childCellCountStack[currentLevel] = nextCount;
			if (nextCount == 0) {
				leftColliderStackSize -= leftColliderCountStack[currentLevel];
				rightColliderStackSize -= rightColliderCountStack[currentLevel];
			}
		}

		pushCell(GlobalCellIndex.zero);

		while (searchStackSize > 0) {
			popCell();

			this.detectInCell(
				currentLeftCell,
				currentRightCell,
				leftColliderStack,
				leftColliderStackSize,
				rightColliderStack,
				rightColliderStackSize,
				onOverlap
			);

			var childCellCount = 0;
			for (childIndex in currentIndex.children(leftQuadtree)) {
				if (leftQuadtree[childIndex].isActive) {
					++childCellCount;
					pushCell(childIndex);
				}
			}
			if (childCellCount != 0) pushColliders(childCellCount);
			else countDown();
		}
	}

	function pushLeftColliders(
		cell: Cell,
		colliderStack: WritableVector<Collider>,
		colliderStackSize: Int
	): Int {
		throw new NotOverriddenException();
	}

	inline function pushRightColliders(
		cell: Cell,
		colliderStack: WritableVector<Collider>,
		colliderStackSize: Int
	): Int {
		cell.exportTo(colliderStack, colliderStackSize);
		return cell.colliderCount;
	}

	function detectInCell(
		leftCell: Cell,
		rightCell: Cell,
		leftColliderStack: WritableVector<Collider>,
		leftColliderStackSize: Int,
		rightColliderStack: WritableVector<Collider>,
		rightColliderStackSize: Int,
		onOverlap: (a: Collider, b: Collider) -> Void
	): Void {
		throw new NotOverriddenException();
	}
}

/**
	Object that performs round-robin collision detection within one single collider group.
	`this.leftQuadtree` and `this.rightQuadtree` are identical.
**/
class IntraGroupCollisionDetector extends CollisionDetector {
	public function new(
		partitionLevel: PartitionLevel,
		maxColliderCount: Int,
		?quadtree: Quadtree
	) {
		final quadtree = if (quadtree != null) {
			if (quadtree.cellCount != partitionLevel.totalCellCount())
				throw new Exception("Partition level of quadtree does not match.");
			quadtree;
		} else new Quadtree(partitionLevel);

		super(quadtree, quadtree, 0, maxColliderCount, partitionLevel);
	}

	override inline function pushLeftColliders(
		cell: Cell,
		colliderStack: WritableVector<Collider>,
		colliderStackSize: Int
	): Int {
		return 0;
	}

	override inline function detectInCell(
		leftCell: Cell,
		rightCell: Cell,
		leftColliderStack: WritableVector<Collider>,
		leftColliderStackSize: Int,
		rightColliderStack: WritableVector<Collider>,
		rightColliderStackSize: Int,
		onOverlap: (a: Collider, b: Collider) -> Void
	): Void {
		leftCell.roundRobin(onOverlap);

		leftCell.detectCollisionWithVector(
			rightColliderStack,
			rightColliderStackSize,
			onOverlap
		);
	}
}

/**
	Object that performs nested-loop collision detection between two collider groups.
**/
class InterGroupCollisionDetector extends CollisionDetector {
	public function new(
		partitionLevel: PartitionLevel,
		leftGroupMaxColliderCount: Int,
		rightGroupMaxColliderCount: Int,
		?leftQuadtree: Quadtree,
		?rightQuadtree: Quadtree
	) {
		final leftQuadtree = if (leftQuadtree != null) {
			if (leftQuadtree.cellCount != partitionLevel.totalCellCount())
				throw new Exception("Partition level of leftQuadtree does not match.");
			leftQuadtree;
		} else new Quadtree(partitionLevel);

		final rightQuadtree = if (rightQuadtree != null) {
			if (rightQuadtree.cellCount != partitionLevel.totalCellCount())
				throw new Exception("Partition level of rightQuadtree does not match.");
			rightQuadtree;
		} else new Quadtree(partitionLevel);

		super(
			leftQuadtree,
			rightQuadtree,
			leftGroupMaxColliderCount,
			rightGroupMaxColliderCount,
			partitionLevel
		);
	}

	override inline function pushLeftColliders(
		cell: Cell,
		colliderStack: WritableVector<Collider>,
		colliderStackSize: Int
	): Int {
		cell.exportTo(colliderStack, colliderStackSize);
		return cell.colliderCount;
	}

	override inline function detectInCell(
		leftCell: Cell,
		rightCell: Cell,
		leftColliderStack: WritableVector<Collider>,
		leftColliderStackSize: Int,
		rightColliderStack: WritableVector<Collider>,
		rightColliderStackSize: Int,
		onOverlap: (a: Collider, b: Collider) -> Void
	): Void {
		leftCell.exportTo(leftColliderStack, leftColliderStackSize);
		rightCell.exportTo(rightColliderStack, rightColliderStackSize);

		for (leftIndex in 0...leftColliderStackSize + leftCell.colliderCount) {
			final leftCollider = leftColliderStack[leftIndex];
			for (rightIndex in 0...rightColliderStackSize + rightCell.colliderCount) {
				final rightCollider = rightColliderStack[rightIndex];
				if (leftCollider.overlaps(rightCollider))
					onOverlap(leftCollider, rightCollider);
			}
		}
	}
}
