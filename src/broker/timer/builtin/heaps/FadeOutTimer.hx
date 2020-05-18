package broker.timer.builtin.heaps;

#if heaps
import banker.pool.SafeObjectPool;
import broker.timer.Timer;

class FadeOutTimer extends ObjectTimer<h2d.Object> {
	/**
		If `true`, calls `object.remove()` when completing.
	**/
	public var removeOnComplete: Bool = false;

	public function new()
		super();

	override function onProgress(progress: Float): Void {
		this.object.alpha = 1.0 - progress;
	}

	override function onComplete(): Void {
		super.onComplete();

		final object = this.object;

		if (this.removeOnComplete)
			object.remove();
		else
			object.alpha = 0.0;
	}
}

final class PooledFadeOutTimer extends FadeOutTimer {
	/**
		The object pool to which `this` belongs.
	**/
	var pool: SafeObjectPool<PooledFadeOutTimer>;

	public function new(pool: SafeObjectPool<PooledFadeOutTimer>) {
		super();
		this.pool = pool;
	}

	override function onComplete(): Void {
		super.onComplete();
		this.pool.put(this);
	}
}

class FadeOutTimerPool extends SafeObjectPool<PooledFadeOutTimer> {
	public function new(capacity: UInt) {
		super(capacity, () -> new PooledFadeOutTimer(this));
	}

	override public function get(): PooledFadeOutTimer {
		throw "Not implemented. Call use() instead of get().";
	}

	/**
		Returns a `PooledFadeOutTimer` instance that is currently not in use,
		and also resets some variables. Use this method instead of `get()`.

		The instance is automatically recycled when completed so that it can be reused again
		(so `step()` should not be called again after completing).

		@param object The object to change the alpha value.
		@param duration
		@param removeOnComplete If `true`, calls `object.remove()` when completing.
		@return A `PooledFadeOutTimer` instance.
	**/
	@:access(broker.timer.builtin.heaps.PooledFadeOutTimer)
	public function use(
		object: h2d.Object,
		duration: UInt,
		removeOnComplete = false
	): PooledFadeOutTimer {
		final timer = super.get();
		TimerExtension.reset(timer, duration);
		timer.object = object;
		final pool: SafeObjectPool<PooledFadeOutTimer> = this;
		timer.pool = pool;
		timer.removeOnComplete = removeOnComplete;
		return timer;
	}
}
#end
