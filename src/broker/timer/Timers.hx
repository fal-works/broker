package broker.timer;

import banker.vector.WritableVector;
import banker.vector.VectorTools;

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

	/**
		Number of `Timer` instances in `bufferVector`.
	**/
	var bufferSize: UInt;

	/**
		Internal buffer vector of `Timer` instances which are to be added to `vector` in `step()`.
	**/
	final bufferVector: WritableVector<Timer>;

	/**
		Creates a `Timers` instance.
		@param capacity The max number of timer instances.
	**/
	public function new(capacity: UInt) {
		this.vector = new WritableVector(capacity);
		this.size = UInt.zero;
		this.bufferVector = new WritableVector(capacity);
		this.bufferSize = UInt.zero;
	}

	/**
		Pushes `timer` to `this`.
	**/
	public inline function push(timer: Timer): Void {
		final index = this.bufferSize;
		this.bufferVector[index] = timer;
		this.bufferSize = index.plusOne();
		timer.setParent(this);
	}

	/**
		Steps all timers and removes the completed ones.
	**/
	public function step(): Void {
		final vector = this.vector;
		var size = this.size;

		final bufferSize = this.bufferSize;
		if (!bufferSize.isZero()) {
			VectorTools.blit(this.bufferVector, 0, vector, size, bufferSize);
			this.bufferSize = UInt.zero;
			size += bufferSize;
		}

		var readIndex = UInt.zero;
		var writeIndex = UInt.zero;
		while (readIndex < size) {
			final timer = vector[readIndex];
			++readIndex;
			if (timer.step()) {
				timer.clearParent();
				continue;
			}
			vector[writeIndex] = timer;
			++writeIndex;
		}

		this.size = writeIndex;
	}

	/**
		Clears all timers.
	**/
	public function clear(): Void {
		final size = this.size;
		final vector = this.vector;
		for (i in 0...size) {
			final timer = vector[i];
			timer.clearParent();
			// TODO: Force complete? Return to pools?
		}

		this.size = UInt.zero;
		this.bufferSize = UInt.zero;
	}
}
