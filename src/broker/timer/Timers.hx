package broker.timer;

import banker.vector.WritableVector;

// TODO: use banker.container.ArrayList or something

/**
	List of `Timer` instances.
**/
class Timers {
	/**
		Number of `Timer` instances that are currently running.
	**/
	public var size: UInt;

	/**
		Internal vector of `Timer` instances.
	**/
	final vector: WritableVector<Timer>;

	public function new(capacity: UInt) {
		this.vector = new WritableVector(capacity);
		this.size = UInt.zero;
	}

	/**
		Pushes `timer` to `this`.
	**/
	public inline function push(timer: Timer): Void {
		final index = this.size;
		this.vector[index] = timer;
		this.size = index.plusOne();
	}

	/**
		Steps all timers and removes the completed ones.
	**/
	public function step(): Void {
		final len = this.size;
		final vector = this.vector;
		var readIndex = UInt.zero;
		var writeIndex = UInt.zero;
		while (readIndex < len) {
			final element = vector[readIndex];
			++readIndex;
			if (element.step()) continue;
			vector[writeIndex] = element;
			++writeIndex;
		}

		this.size = writeIndex;
	}

	/**
		Clears all timers.
	**/
	public function clear(): Void {
		this.size = UInt.zero;
	}
}
