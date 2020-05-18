package broker.timer.builtin.heaps;

#if heaps
import banker.pool.SafeObjectPool;
import broker.timer.Timer;
import broker.timer.builtin.heaps.ObjectTimer;

class FadeInTimer extends ObjectTimer<h2d.Object> {
	/**
		Object pool for `FadeInTimer`.
	**/
	public static final pool = {
		final pool: SafeObjectPool<FadeInTimer> = new SafeObjectPool(UInt.one, () -> new FadeInTimer());
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
	public static function use(object: h2d.Object, duration: UInt): FadeInTimer {
		final timer = pool.get();
		TimerExtension.reset(timer, duration);
		timer.object = object;
		return timer;
	}

	public function new()
		super();

	override function onProgress(progress: Float): Void {
		this.object.alpha = progress;
	}

	override function onComplete(): Void {
		super.onComplete();
		this.object.alpha = 1.0;
		pool.put(this);
	}
}
#end
