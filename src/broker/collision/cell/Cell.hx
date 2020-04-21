package broker.collision.cell;

import banker.vector.WritableVector;
import banker.vector.VectorReference;

/**
	Node of quadtree, i.e. an unit of partitioned space in any partition level.
**/
class Cell {
	/**
		The `PartitionLevel` to which `this` belongs.
	**/
	public final level: PartitionLevel;

	/**
		The number of `Collider`s that are registered to `this`.
	**/
	public var colliderCount: UInt;

	/**
		`true` if `this` or any of its descendants contains colliders.
	**/
	public var isActive: Bool;

	/**
		The top node of linked list of colliders. This is always a dummy sentinel node.
	**/
	final top: Collider;

	/**
		The last node of linked list of colliders.
	**/
	var last: Collider;

	public function new(level: PartitionLevel) {
		this.level = level;
		this.colliderCount = UInt.zero;
		this.isActive = false;

		final dummyCollider = new Collider(-1);
		this.top = dummyCollider;
		this.last = dummyCollider;
	}

	/**
		Adds `collider` to `this` cell.
		Also unlinks the next node of `collider` so that `collider` is the last node in the linked list.
	**/
	public inline function add(collider: Collider): Void {
		this.last.next = collider;
		this.last = collider;
		collider.unlink();
		++this.colliderCount;
	}

	/**
		Clears and deactivates `this` cell.
	**/
	public inline function clear(): Void {
		this.colliderCount = UInt.zero;
		this.isActive = false;
		this.top.unlink();
		this.last = this.top;
	}

	/**
		Detects overlapping for each `Collider` combination pair within `this` cell.
	**/
	public function roundRobin(
		onOverlap: (colliderA: Collider, collierB: Collider) -> Void
	): Void {
		final lastCollider = this.last;
		var currentA = this.top.next;
		while (currentA.isSome()) {
			final colliderA = currentA.unwrap();
			if (colliderA == lastCollider) break;

			var currentB = colliderA.next;
			while (currentB.isSome()) {
				final colliderB = currentB.unwrap();

				if (colliderA.overlaps(colliderB))
					onOverlap(colliderA, colliderB);

				currentB = colliderB.next;
			}

			currentA = colliderA.next;
		}
	}

	/**
		Assigns all `Collider`s of `this` to `output`.
		@param startIndex The index to start writing to `output`.
	**/
	public inline function exportTo(
		output: WritableVector<Collider>,
		startIndex: UInt
	): Void {
		var current = this.top.next;
		var writeIndex = startIndex;

		while (current.isSome()) {
			final thisCollider = current.unwrap();

			output[writeIndex] = thisCollider;
			++writeIndex;

			current = thisCollider.next;
		}
	}

	/**
		Detects overlapping of `Collider`s between `this` cell and `otherColliders`.
	**/
	public inline function detectCollisionWithVector(
		otherColliders: VectorReference<Collider>,
		otherCollidersCount: UInt,
		onOverlap: (colliderA: Collider, colliderB: Collider) -> Void
	): Void {
		final firstThisCollider = this.top.next;

		inline function u(v: Int)
			return @:privateAccess new UInt(v);

		for (i in 0...otherCollidersCount) {
			final otherCollider = otherColliders[u(i)];

			var current = firstThisCollider;
			while (current.isSome()) {
				final thisCollider = current.unwrap();

				if (thisCollider.overlaps(otherCollider))
					onOverlap(thisCollider, otherCollider);

				current = thisCollider.next;
			}
		}
	}
}
