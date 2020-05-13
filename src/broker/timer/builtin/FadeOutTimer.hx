package broker.timer.builtin;

import banker.pool.SafeObjectPool;
import broker.timer.TimerBase;

class FadeOutTimer extends TimerBase {
	/**
		Object pool for `FadeOutTimer`.
	**/
	public static final pool = {
		final pool = new SafeObjectPool(UInt.one, () -> new FadeOutTimer());
		pool.newTag("FadeOutTimer pool");
		pool;
	}

	/**
		Dummy object to be assigned when insantiating `FadeOutTimer`.
	**/
	static final dummyObject = new h2d.Object();

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
		removeOnComplete = true
	): FadeOutTimer {
		return pool.get().set(object, duration, removeOnComplete);
	}

	var object: h2d.Object;
	var removeOnComplete: Bool;

	public function new() {
		super();
		this.object = dummyObject;
		this.removeOnComplete = true;
	}

	public function set(
		object: h2d.Object,
		duration: UInt,
		removeOnComplete: Bool
	): FadeOutTimer {
		this.object = object;
		this.setDuration(duration);
		this.removeOnComplete = removeOnComplete;

		return this;
	}

	override public function onProgress(progress: Float): Void {
		this.object.alpha = 1.0 - progress;
	}

	override public function onComplete(): Void {
		if (this.removeOnComplete)
			this.object.remove();
		else
			this.object.alpha = 0.0;

		pool.put(this);
	}
}
