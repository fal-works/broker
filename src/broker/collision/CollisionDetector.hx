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
	static var leftColliderCountStack: WritableVector<UInt> = WritableVector.createZero();

	/**
		Shared vector for using as a stack storing right group `Collider`s in ancestor `Cell`s
		when traversing a quadtree.
	**/
	static var rightColliderStack: WritableVector<Collider> = WritableVector.createZero();

	/**
		Shared vector for storing the number of right group `Collider`s in each `Cell`.
	**/
	static var rightColliderCountStack: WritableVector<UInt> = WritableVector.createZero();

	/**
		Shared vector for using as a stack for depth-first search in quadtree.
	**/
	static var childCellCountStack: WritableVector<UInt> = WritableVector.createZero();

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
		maxColliderCount: UInt,
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
			left: { maxColliderCount: UInt, ?quadtree: Quadtree },
			right: { maxColliderCount: UInt, ?quadtree: Quadtree }
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
		leftColliderStackCapacity: UInt,
		rightColliderStackCapacity: UInt,
		partitionLevel: PartitionLevel
	) {
		this.leftQuadtree = leftQuadtree;
		this.rightQuadtree = rightQuadtree;

		if (leftColliderStack.length < leftColliderStackCapacity)
			leftColliderStack = new WritableVector(leftColliderStackCapacity);

		if (rightColliderStack.length < rightColliderStackCapacity)
			rightColliderStack = new WritableVector(rightColliderStackCapacity);

		final level = partitionLevel.uint();
		final levelPlusOne = level + 1;

		if (childCellCountStack.length < levelPlusOne)
			childCellCountStack = new WritableVector(levelPlusOne);

		if (leftColliderCountStack.length < levelPlusOne)
			leftColliderCountStack = new WritableVector(levelPlusOne);

		if (rightColliderCountStack.length < levelPlusOne)
			rightColliderCountStack = new WritableVector(levelPlusOne);

		final searchStackSize = UInts.pow(4, level);
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
		var currentLevel = UInt.zero;
		var searchStackSize = UInt.zero;
		var leftColliderStackSize = UInt.zero;
		var rightColliderStackSize = UInt.zero;

		inline function pushCell(index: GlobalCellIndex): Void {
			searchStack[searchStackSize] = index;
			++searchStackSize;
		}
		inline function popCell(): Void {
			--searchStackSize;
			currentIndex = searchStack[searchStackSize];
			currentLeftCell = leftQuadtree[currentIndex];
			currentRightCell = rightQuadtree[currentIndex];
			currentLevel = currentLeftCell.level.uint();
		}

		inline function pushColliders(childCount: UInt): Void {
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
			final currentCount = childCellCountStack[currentLevel];
			switch currentCount {
				case UInt.zero:
				case UInt.one:
					childCellCountStack[currentLevel] = UInt.zero;
					leftColliderStackSize -= leftColliderCountStack[currentLevel];
					rightColliderStackSize -= rightColliderCountStack[currentLevel];
				default:
					childCellCountStack[currentLevel] = currentCount - 1;
			}
		}

		pushCell(GlobalCellIndex.zero);

		while (!searchStackSize.isZero()) {
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

			var childCellCount = UInt.zero;
			for (i in currentIndex.children(leftQuadtree)) {
				final childIndex = new GlobalCellIndex(i);
				if (leftQuadtree[childIndex].isActive) {
					++childCellCount;
					pushCell(childIndex);
				}
			}
			if (!childCellCount.isZero()) pushColliders(childCellCount);
			else countDown();
		}
	}

	function pushLeftColliders(
		cell: Cell,
		colliderStack: WritableVector<Collider>,
		colliderStackSize: UInt
	): UInt {
		throw new NotOverriddenException();
	}

	function pushRightColliders(
		cell: Cell,
		colliderStack: WritableVector<Collider>,
		colliderStackSize: UInt
	): UInt {
		throw new NotOverriddenException();
	}

	function detectInCell(
		leftCell: Cell,
		rightCell: Cell,
		leftColliderStack: WritableVector<Collider>,
		leftColliderStackSize: UInt,
		rightColliderStack: WritableVector<Collider>,
		rightColliderStackSize: UInt,
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
		maxColliderCount: UInt,
		?quadtree: Quadtree
	) {
		final quadtree = if (quadtree != null) {
			if (quadtree.cellCount != partitionLevel.totalCellCount())
				throw new Exception("Partition level of quadtree does not match.");
			quadtree;
		} else new Quadtree(partitionLevel);

		super(quadtree, quadtree, UInt.zero, maxColliderCount, partitionLevel);
	}

	override inline function pushLeftColliders(
		cell: Cell,
		colliderStack: WritableVector<Collider>,
		colliderStackSize: UInt
	): UInt {
		return UInt.zero;
	}

	override inline function pushRightColliders(
		cell: Cell,
		colliderStack: WritableVector<Collider>,
		colliderStackSize: UInt
	): UInt {
		cell.exportTo(colliderStack, colliderStackSize);
		return cell.colliderCount;
	}

	override inline function detectInCell(
		leftCell: Cell,
		rightCell: Cell,
		leftColliderStack: WritableVector<Collider>,
		leftColliderStackSize: UInt,
		rightColliderStack: WritableVector<Collider>,
		rightColliderStackSize: UInt,
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
		leftGroupMaxColliderCount: UInt,
		rightGroupMaxColliderCount: UInt,
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
		colliderStackSize: UInt
	): UInt {
		// cell is already exported to colliderStack in detectInCell() called just before
		return cell.colliderCount;
	}

	override inline function pushRightColliders(
		cell: Cell,
		colliderStack: WritableVector<Collider>,
		colliderStackSize: UInt
	): UInt {
		// cell is already exported to colliderStack in detectInCell() called just before
		return cell.colliderCount;
	}

	override inline function detectInCell(
		leftCell: Cell,
		rightCell: Cell,
		leftColliderStack: WritableVector<Collider>,
		leftColliderStackSize: UInt,
		rightColliderStack: WritableVector<Collider>,
		rightColliderStackSize: UInt,
		onOverlap: (a: Collider, b: Collider) -> Void
	): Void {
		leftCell.exportTo(leftColliderStack, leftColliderStackSize);
		rightCell.exportTo(rightColliderStack, rightColliderStackSize);

		inline function u(v: Int)
			return @:privateAccess new UInt(v);

		for (leftIndex in 0...leftColliderStackSize + leftCell.colliderCount) {
			final leftCollider = leftColliderStack[u(leftIndex)];

			for (rightIndex in 0...rightColliderStackSize + rightCell.colliderCount) {
				final rightCollider = rightColliderStack[u(rightIndex)];

				if (leftCollider.overlaps(rightCollider))
					onOverlap(leftCollider, rightCollider);
			}
		}
	}
}
