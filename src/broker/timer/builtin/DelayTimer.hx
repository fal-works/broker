package broker.timer.builtin;

import banker.pool.interfaces.ObjectPool;
import banker.pool.SafeObjectPool;
import broker.timer.Timer;

/**
	`Timer` that just waits for a specific duration.
**/
class DelayTimer extends Timer {
	public function new()
		super();
}

/**
	Extended `DelayTimer` that is automatically recycled when completed.
**/
final class PooledDelayTimer extends DelayTimer {
	/**
		The object pool to which `this` belongs.
	**/
	var pool: ObjectPool<PooledDelayTimer>;

	public function new(pool: ObjectPool<PooledDelayTimer>) {
		super();
		this.pool = pool;
	}

	override function onComplete(): Void {
		super.onComplete();
		this.pool.put(this);
	}
}

class DelayTimerPool extends SafeObjectPool<PooledDelayTimer> {
	public function new(capacity: UInt) {
		super(capacity, () -> new PooledDelayTimer(this));
	}

	/**
		This operation is not supported. Call `use()` instead.
	**/
	override public function get(): PooledDelayTimer {
		throw "Not implemented. Call use() instead of get().";
	}

	/**
		Gets a `PooledDelayTimer` instance that is currently not in use,
		and also resets some variables. Use this method instead of `get()`.

		The instance is automatically recycled when completed so that it can be reused again
		(so `step()` should not be called again after completing).

		@param duration The delay duration frame count.
		@return A `PooledDelayTimer` instance.
	**/
	@:access(broker.timer.builtin.PooledDelayTimer)
	public function use(duration: UInt): PooledDelayTimer {
		final timer = super.get();
		TimerExtension.reset(timer, duration);
		timer.pool = this;
		return timer;
	}
}
