package broker.timer.builtin;

import banker.pool.interfaces.ObjectPool;
import banker.pool.SafeObjectPool;
import broker.object.Object;
import broker.timer.Timer;

/**
	`Timer` that applies fade-in effect on any `Object` instance.
**/
#if !broker_generic_disable
@:generic
#end
class FadeInTimer extends ObjectTimer {
	public function new(object: Object) {
		super(object);
	}

	override function onProgress(progress: Float): Void {
		this.object.alpha = progress;
	}

	override function onComplete(): Void {
		super.onComplete();
		this.object.alpha = 1.0;
	}
}

/**
	Extended `FadeInTimer` that is automatically recycled when completed.
**/
#if !broker_generic_disable
@:generic
#end
final class PooledFadeInTimer extends FadeInTimer {
	/**
		The object pool to which `this` belongs.
	**/
	var pool: ObjectPool<PooledFadeInTimer>;

	public function new(pool: ObjectPool<PooledFadeInTimer>) {
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
class FadeInTimerPool extends SafeObjectPool<PooledFadeInTimer> {
	public function new(capacity: UInt) {
		super(capacity, () -> new PooledFadeInTimer(this));
	}

	/**
		This operation is not supported. Call `use()` instead.
	**/
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
	@:access(broker.timer.builtin.PooledFadeInTimer)
	public function use(object: Object, duration: UInt): PooledFadeInTimer {
		final timer = super.get();
		TimerExtension.reset(timer, duration);
		timer.object = object;
		timer.pool = this;
		return timer;
	}
}
