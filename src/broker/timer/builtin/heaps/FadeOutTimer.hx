package broker.timer.builtin.heaps;

#if heaps
import banker.pool.SafeObjectPool;
import broker.timer.Timer;

final class FadeOutTimer extends ObjectTimer<h2d.Object> {
	/**
		The object pool to which `this` belongs.
	**/
	var pool: Maybe<SafeObjectPool<FadeOutTimer>>;

	/**
		If `true`, calls `object.remove()` when completing.
	**/
	var removeOnComplete: Bool = false;

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

		final pool = this.pool;
		if (pool.isSome()) {
			pool.unwrap().put(this);
			this.pool = Maybe.none();
		}
	}
}

class FadeOutTimerTools {
	/**
		Global object pool for `FadeOutTimer`.
	**/
	public static final pool = {
		final pool = new SafeObjectPool(UInt.one, () -> new FadeOutTimer());
		pool.newTag("FadeOutTimer pool");
		pool;
	}

	/**
		Returns a `FadeOutTimer` instance that is currently not in use.

		The instance is automatically recycled when completed so that it can be reused again
		(so `step()` should not be called again after completing).

		@param object The object to change the alpha value.
		@param duration
		@param removeOnComplete If `true`, calls `object.remove()` when completing.
		@return A `FadeOutTimer` instance.
	**/
	@:access(broker.timer.builtin.heaps.FadeOutTimer)
	public static function use(
		object: h2d.Object,
		duration: UInt,
		removeOnComplete = false
	): FadeOutTimer {
		final timer = pool.get();
		TimerExtension.reset(timer, duration);
		timer.object = object;
		timer.removeOnComplete = removeOnComplete;
		return timer;
	}
}
#end
