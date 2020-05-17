package broker.timer.builtin.heaps;

#if heaps
import banker.pool.SafeObjectPool;

class FadeOutTimer extends FadeTimerBase {
	/**
		Object pool for `FadeOutTimer`.
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
	public static function use(
		object: h2d.Object,
		duration: UInt,
		removeOnComplete = false
	): FadeOutTimer {
		final timer = pool.get();
		timer.reset(object, duration);
		timer.removeOnComplete = removeOnComplete;
		return timer;
	}

	/**
		If `true`, calls `object.remove()` when completing.
	**/
	var removeOnComplete: Bool = false;

	public function new()
		super();

	override function reset(object: h2d.Object, duration: UInt): Void {
		super.reset(object, duration);
		this.removeOnComplete = false;
	}

	override function onProgress(progress: Float): Void {
		super.onProgress(progress);
		this.object.alpha = 1.0 - progress;
	}

	override function onComplete(): Void {
		super.onComplete();

		final object = this.object;

		if (this.removeOnComplete)
			object.remove();
		else
			object.alpha = 0.0;

		pool.put(this);
	}
}
#end
