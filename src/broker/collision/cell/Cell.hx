package broker.collision.cell;

/**
	Node of quadtree, i.e. an unit of partitioned space in any partition level.
**/
class Cell {
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

	public function new() {
		final dummyCollider = new Collider(-1);

		this.top = dummyCollider;
		this.last = dummyCollider;
		this.isActive = false;
	}

	/**
		Adds `collider` to `this` cell.
		Also unlinks the next node of `collider` so that `collider` is the last node in the linked list.
	**/
	public inline function add(collider: Collider): Void {
		this.last.next = collider;
		this.last = collider;
		collider.unlink();
	}

	/**
		Clears and deactivates `this` cell.
	**/
	public inline function clear(): Void {
		this.top.unlink();
		this.last = this.top;
		this.isActive = false;
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
		Detects overlapping of `Collider`s between `this` cell and `otherCell`.
	**/
	public function nestedLoopJoin(
		otherCell: Cell,
		onOverlap: (colliderA: Collider, colliderB: Collider) -> Void
	): Void {
		final otherFirst = otherCell.top.next;

		var currentA = this.top.next;
		while (currentA.isSome()) {
			final colliderA = currentA.unwrap();

			var currentB = otherFirst;
			while (currentB.isSome()) {
				final colliderB = currentB.unwrap();

				if (colliderA.overlaps(colliderB))
					onOverlap(colliderA, colliderB);

				currentB = colliderB.next;
			}

			currentA = colliderA.next;
		}
	}
}
