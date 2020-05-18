package broker.timer.builtin.heaps;

#if heaps
import banker.pool.SafeObjectPool;
import broker.timer.Timer;
import broker.timer.builtin.heaps.ObjectTimer;

final class FadeInTimer extends ObjectTimer<h2d.Object> {
	/**
		The object pool to which `this` belongs.
	**/
	var pool: Maybe<SafeObjectPool<FadeInTimer>>;

	public function new() {
		super();
		this.pool = Maybe.none();
	}

	override function onProgress(progress: Float): Void {
		this.object.alpha = progress;
	}

	override function onComplete(): Void {
		super.onComplete();
		this.object.alpha = 1.0;

		final pool = this.pool;
		if (pool.isSome()) {
			pool.unwrap().put(this);
			this.pool = Maybe.none();
		}
	}
}

class FadeInTimerPool extends SafeObjectPool<FadeInTimer> {
	public final putCallback: (timer: FadeInTimer) -> Void;

	public function new() {
		super(UInt.one, () -> new FadeInTimer());
		this.putCallback = (timer: FadeInTimer) -> this.put(timer);
	}

	/**
		Returns a `FadeInTimer` instance that is currently not in use.

		The instance is automatically recycled when completed so that it can be reused again
		(so `step()` should not be called again after completing).

		@param object The object to change the alpha value.
		@param duration
		@return A `FadeInTimer` instance.
	**/
	@:access(broker.timer.builtin.heaps.FadeInTimer)
	public function use(object: h2d.Object, duration: UInt): FadeInTimer {
		final timer = this.get();
		TimerExtension.reset(timer, duration);
		timer.object = object;
		final pool: SafeObjectPool<FadeInTimer> = this;
		timer.pool = pool;
		return timer;
	}
}
#end
