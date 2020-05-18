package broker.timer.builtin.heaps;

#if heaps
import banker.pool.SafeObjectPool;
import broker.timer.Timer;
import broker.timer.builtin.heaps.ObjectTimer;

class FadeInTimer extends ObjectTimer<h2d.Object> {
	public function new() {
		super();
	}

	override function onProgress(progress: Float): Void {
		this.object.alpha = progress;
	}

	override function onComplete(): Void {
		super.onComplete();
		this.object.alpha = 1.0;
	}
}

final class PooledFadeInTimer extends FadeInTimer {
	/**
		The object pool to which `this` belongs.
	**/
	var pool: SafeObjectPool<PooledFadeInTimer>;

	public function new(pool: SafeObjectPool<PooledFadeInTimer>) {
		super();
		this.pool = pool;
	}

	override function onComplete(): Void {
		super.onComplete();
		this.pool.put(this);
	}
}

class FadeInTimerPool extends SafeObjectPool<PooledFadeInTimer> {
	public function new(capacity: UInt) {
		super(capacity, () -> new PooledFadeInTimer(this));
	}

	override public function get(): PooledFadeInTimer {
		throw "Not implemented. Call use() instead of get().";
	}

	/**
		Gets a `PooledFadeInTimer` instance that is currently not in use,
		and also resets some variables. Use this method instead of `get()`.

		The instance is automatically recycled when completed so that it can be reused again
		(so `step()` should not be called again after completing).

		@param object The object to change the alpha value.
		@param duration
		@return A `PooledFadeInTimer` instance.
	**/
	@:access(broker.timer.builtin.heaps.PooledFadeInTimer)
	public function use(object: h2d.Object, duration: UInt): PooledFadeInTimer {
		final timer = super.get();
		TimerExtension.reset(timer, duration);
		timer.object = object;
		final pool: SafeObjectPool<PooledFadeInTimer> = this;
		timer.pool = pool;
		return timer;
	}
}
#end
