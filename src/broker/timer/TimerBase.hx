package broker.timer;

/**
	Base class for implementing `broker.timer.Timer`.
	Extend this class for your own purpose.
**/
class TimerBase implements Timer {
	/**
		Current progress rate. Is increased in `this.step()`.
	**/
	public var progress: Float;

	/**
		Change rate of `this.progress`.
	**/
	var progressChangeRate: Float;

	/**
		Creates a `Timer` instance.
		@param duration Defaults to `1`. Infinite loop if zero.
	**/
	public function new(duration: UInt = UInt.one) {
		this.progress = 0.0;
		this.progressChangeRate = if (duration.isZero()) 0.0 else 1.0 / duration;
	}

	/**
		Sets the duration of `this` timer and resets `this.progress`.
		@param duration Infinite loop if zero.
		@return `this`.
	**/
	public inline function setDuration(duration: UInt): Timer {
		this.progress = 0.0;
		this.progressChangeRate = if (duration.isZero()) 0.0 else 1.0 / duration;
		return this;
	}

	/**
		Steps `this` timer.
		- If not yet completed (`this.progress < 1.0`), runs `this.onProgress()` and then adds `this.progress`.
		- If completed, runs `this.onComplete()`.
		@return `true` if completed. Otherwise `false`.
	**/
	public inline function step(): Bool {
		final progress = this.progress;

		if (progress < 1.0) {
			this.onProgress(progress);
			this.progress = progress + this.progressChangeRate;
			return false;
		} else {
			this.onComplete();
			return true;
		}
	}

	/**
		Called every time `this.step()` is called.
		Override this method for your own purpose.
	**/
	public function onProgress(progress: Float): Void {}

	/**
		Called once when this timer is completed.
		Override this method for your own purpose.
	**/
	public function onComplete(): Void {}
}
