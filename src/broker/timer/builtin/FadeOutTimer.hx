package broker.timer.builtin;

import banker.pool.interfaces.ObjectPool;
import banker.pool.SafeObjectPool;
import broker.object.Object;
import broker.timer.Timer;

/**
	`Timer` that applies fade-out effect on any `Object` instance.
**/
#if !broker_generic_disable
@:generic
#end
class FadeOutTimer extends ObjectTimer {
	public function new(object: Object)
		super(object);

	override function onProgress(progress: Float): Void {
		this.object.alpha = 1.0 - progress;
	}

	override function onComplete(): Void {
		super.onComplete();
		this.object.alpha = 0.0;
	}
}

/**
	Extended `FadeOutTimer` that is automatically recycled when completed.
**/
#if !broker_generic_disable
@:generic
#end
final class PooledFadeOutTimer extends FadeOutTimer {
	/**
		The object pool to which `this` belongs.
	**/
	var pool: ObjectPool<PooledFadeOutTimer>;

	public function new(pool: ObjectPool<PooledFadeOutTimer>) {
		super(cast null);
		this.pool = pool;
	}

	override function onComplete(): Void {
		super.onComplete();
		this.pool.put(this);
	}
}

#if !broker_generic_disable
@:generic
#end
@:ripper_verified
class FadeOutTimerPool extends SafeObjectPool<PooledFadeOutTimer> {
	public function new(capacity: UInt) {
		super(capacity, () -> new PooledFadeOutTimer(this));
	}

	/**
		This operation is not supported. Call `use()` instead.
	**/
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
	@:access(broker.timer.builtin.PooledFadeOutTimer)
	public function use(
		object: Object,
		duration: UInt
	): PooledFadeOutTimer {
		final timer = super.get();
		TimerExtension.reset(timer, duration);
		timer.object = object;
		timer.pool = this;
		return timer;
	}
}
