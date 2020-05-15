package broker.timer.builtin;

import banker.pool.SafeObjectPool;

class FadeInTimer extends FadeTimerBase {
	/**
		Object pool for `FadeInTimer`.
	**/
	public static final pool = {
		final pool = new SafeObjectPool(UInt.one, () -> new FadeInTimer());
		pool.newTag("FadeInTimer pool");
		pool;
	}

	/**
		Returns a `FadeInTimer` instance that is currently not in use.

		The instance is automatically recycled when completed so that it can be reused again
		(so `step()` should not be called again after completing).

		@param object The object to change the alpha value.
		@param duration
		@return A `FadeInTimer` instance.
	**/
	public static function use(
		object: h2d.Object,
		duration: UInt,
		?onStart: () -> Void,
		?onProgress: (progress: Float) -> Void,
		?onComplete: () -> Void
	): FadeInTimer {
		final timer = pool.get();
		timer.reset(object, duration, onStart, onProgress, onComplete);
		return timer;
	}

	public function new()
		super();

	override public function onProgress(progress: Float): Void {
		super.onProgress(progress);
		this.object.alpha = progress;
	}

	override public function onComplete(): Void {
		super.onComplete();
		this.object.alpha = 1.0;
		pool.put(this);
	}
}
