package broker.collision;

#if !broker_generic_disable
@:generic
#end
class AbstractCell<T> {
	public function add(collider: Collider<T>): Void {}
}

/**
	Node of `LinearQuadTree`.
**/
#if !broker_generic_disable
@:generic
#end
class Cell<T> extends AbstractCell<T> {
	/**
		`true` if `this` or any of its descendants contains colliders.
	**/
	public var isActive: Bool;

	/**
		The top node of linked list of colliders. This is always a dummy sentinel node.
	**/
	final top: Collider<T>;

	/**
		The last node of linked list of colliders.
	**/
	var last: Collider<T>;

	/**
		@param defaultColliderValue Used for creating a dummy sentinel `Collider`.
	**/
	public function new(defaultColliderValue: T) {
		final dummyCollider = new Collider(defaultColliderValue);

		this.top = dummyCollider;
		this.last = dummyCollider;
		this.isActive = false;
	}

	/**
		Adds `collider` to `this` cell.
		Also unlinks the next node of `collider` so that `collider` is the last node in the linked list.
	**/
	override public inline function add(collider: Collider<T>): Void {
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
		onOverlap: (colliderA: Collider<T>, collierB: Collider<T>) -> Void
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
		otherCell: Cell<T>,
		onOverlap: (colliderA: Collider<T>, colliderB: Collider<T>) -> Void
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

#if !broker_generic_disable
@:generic
#end
class NullCell<T> extends AbstractCell<T> {
	public function new() {}

	override public inline function add(collider: Collider<T>): Void {}
}
