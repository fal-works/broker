package broker.timer;

/**
	Base class for implementing `broker.timer.Timer`.
	Extend this class for your own purpose.
**/
class TimerBase implements Timer {
	static final dummyOnProgressCallback = (progress: Float) -> {};
	static final dummyOnCompleteCallback = () -> {};

	/**
		Current progress rate. Is increased in `this.step()`.
	**/
	public var progress: Float;

	/**
		Change rate of `this.progress`.
	**/
	public var progressChangeRate: Float;

	/**
		Function called in `this.onProgress()`.
	**/
	public var onProgressCallback: (progress: Float) -> Void;

	/**
		Function called in `this.onComplete()`.
	**/
	public var onCompleteCallback: () -> Void;

	/**
		Creates a `Timer` instance.
	**/
	public function new() {
		this.progress = 0.0;
		this.progressChangeRate = 1.0;
		this.onProgressCallback = dummyOnProgressCallback;
		this.onCompleteCallback = dummyOnCompleteCallback;
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
		Sets the callback functions of `this` timer.
		Assigns dummy functions (which have no effects) if not provided.
		@return `this`.
	**/
	public inline function setCallbacks(
		?onProgress: (progress: Float) -> Void,
		?onComplete: () -> Void
	): Timer {
		this.onProgressCallback = Nulls.coalesce(
			onProgress,
			dummyOnProgressCallback
		);
		this.onCompleteCallback = Nulls.coalesce(
			onComplete,
			dummyOnCompleteCallback
		);
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
	public function onProgress(progress: Float): Void {
		this.onProgressCallback(progress);
	}

	/**
		Called once when this timer is completed.
		Override this method for your own purpose.
	**/
	public function onComplete(): Void {
		this.onCompleteCallback();
	}
}
