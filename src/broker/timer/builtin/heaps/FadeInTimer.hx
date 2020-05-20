package broker.timer.builtin.heaps;

#if heaps
import banker.pool.interfaces.ObjectPool;
import banker.pool.SafeObjectPool;
import broker.timer.Timer;
import broker.timer.builtin.heaps.ObjectTimer;

#if !broker_generic_disable
@:generic
#end
class FadeInTimer<T: h2d.Object> extends ObjectTimer<T> {
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

/**
	Extended `FadeInTimer` that is automatically recycled when completed.
**/
#if !broker_generic_disable
@:generic
#end
final class PooledFadeInTimer<T: h2d.Object> extends FadeInTimer<T> {
	/**
		The object pool to which `this` belongs.
	**/
	var pool: ObjectPool<PooledFadeInTimer<T>>;

	public function new(pool: ObjectPool<PooledFadeInTimer<T>>) {
		super();
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
class FadeInTimerPool<T: h2d.Object> extends SafeObjectPool<PooledFadeInTimer<T>> {
	public function new(capacity: UInt) {
		super(capacity, () -> new PooledFadeInTimer(this));
	}

	/**
		This operation is not supported. Call `use()` instead.
	**/
	override public function get(): PooledFadeInTimer<T> {
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
	public function use(object: T, duration: UInt): PooledFadeInTimer<T> {
		final timer = super.get();
		TimerExtension.reset(timer, duration);
		timer.object = object;
		timer.pool = this;
		return timer;
	}
}
#end
