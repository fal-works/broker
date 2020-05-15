package broker.timer;

/**
	Base class for implementing `broker.timer.Timer`.
	Extend this class for your own purpose.
**/
class TimerBase implements Timer {
	static final dummyCallback = () -> {};
	static final dummyOnProgressCallback = (progress: Float) -> {};

	/**
		Current progress rate. Is increased in `this.step()`.
	**/
	public var progress: Float;

	/**
		Change rate of `this.progress`.
	**/
	var progressChangeRate: Float;

	/**
		Function called in `this.onStart()`.
	**/
	var onStartCallback: () -> Void;

	/**
		Function called in `this.onProgress()`.
	**/
	var onProgressCallback: (progress: Float) -> Void;

	/**
		Function called in `this.onComplete()`.
	**/
	var onCompleteCallback: () -> Void;

	/**
		Creates a `Timer` instance.
	**/
	function new() {
		this.progress = 0.0;
		this.progressChangeRate = 1.0;
		this.onStartCallback = dummyCallback;
		this.onProgressCallback = dummyOnProgressCallback;
		this.onCompleteCallback = dummyCallback;
	}

	/**
		Sets the duration of `this` timer and resets `this.progress`.
		@param duration Infinite loop if zero.
		@return `this`.
	**/
	public function setDuration(duration: UInt): Timer {
		this.progress = 0.0;
		this.progressChangeRate = if (duration.isZero()) 0.0 else 1.0 / duration;
		return this;
	}

	/**
		Sets the callback functions of `this` timer.
		Assigns dummy functions (which have no effects) if not provided.
		@return `this`.
	**/
	public function setCallbacks(
		?onStart: () -> Void,
		?onProgress: (progress: Float) -> Void,
		?onComplete: () -> Void
	): Timer {
		this.onStartCallback = Nulls.coalesce(
			onStart,
			dummyCallback
		);
		this.onProgressCallback = Nulls.coalesce(
			onProgress,
			dummyOnProgressCallback
		);
		this.onCompleteCallback = Nulls.coalesce(
			onComplete,
			dummyCallback
		);
		return this;
	}

	/**
		Steps `this` timer.
		- If not yet completed (`progress < 1.0`), runs `onProgress()` and then adds `progress`.
		  If called for the first time, also calls `onStart()` before calling `onProgress()`.
		- If completed, runs `onComplete()`.
		@return `true` if completed. Otherwise `false`.
	**/
	public function step(): Bool {
		final progress = this.progress;

		if (progress == 0.0) {
			this.onStart();
			this.onProgress(progress);
			this.progress = progress + this.progressChangeRate;
			return false;
		} else if (progress < 1.0) {
			this.onProgress(progress);
			this.progress = progress + this.progressChangeRate;
			return false;
		} else {
			this.onComplete();
			return true;
		}
	}

	/**
		Called once when `this.step()` is called for the first time.
		Override this method for your own purpose.
	**/
	function onStart(): Void {
		this.onStartCallback();
	}

	/**
		Called in `this.step()` if this timer is not completed.
		Override this method for your own purpose.
	**/
	function onProgress(progress: Float): Void {
		this.onProgressCallback(progress);
	}

	/**
		Called in `this.step()` if this timer is completed.
		Override this method for your own purpose.
	**/
	function onComplete(): Void {
		this.onCompleteCallback();
	}
}
