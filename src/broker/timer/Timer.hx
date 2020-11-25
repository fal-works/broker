package broker.timer;

import broker.timer.builtin.DelayTimer;

/**
	Basic timer class.
	Can be extended for your own purpose.
**/
@:using(broker.timer.Timer.TimerExtension)
@:structInit
class Timer {
	static final dummyCallback = () -> {};

	/**
		Current progress rate. Is increased in `this.step()`.
	**/
	public var progress(default, null): Float;

	/**
		Change rate of `this.progress`.
	**/
	var progressChangeRate: Float;

	/**
		Function called in `this.onStart()`.
	**/
	var onStartCallback: () -> Void;

	/**
		Function called in `this.onComplete()`.
	**/
	var onCompleteCallback: () -> Void;

	/**
		The next timer that starts once `this` timer is completed
		(i.e. it will be added to `parent` in `this.onComplete()`).
	**/
	var next: Maybe<Timer>;

	/**
		The `Timers` instance to which `this` belongs.
	**/
	var parent: Maybe<Timers>;

	/**
		Creates a `Timer` instance.
	**/
	function new(
		?duration: UInt,
		?onStart: () -> Void,
		?onComplete: () -> Void
	) {
		this.progress = 0.0;
		this.progressChangeRate = 1.0;
		this.onStartCallback = Nulls.coalesce(onStart, dummyCallback);
		this.onCompleteCallback = Nulls.coalesce(onComplete, dummyCallback);
		this.next = Maybe.none();
		this.parent = Maybe.none();

		if (duration != null) this.setDuration(duration);
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
		Clears callback functions of `this` timer.
		@return `this`.
	**/
	public function clearCallbacks(): Timer {
		this.onStartCallback = dummyCallback;
		this.onCompleteCallback = dummyCallback;
		return this;
	}

	/**
		Sets `onStart` callback function.
		@return `this`.
	**/
	public function setOnStart(callback: () -> Void): Timer {
		this.onStartCallback = callback;
		return this;
	}

	/**
		Sets `onComplete` callback function.
		@return `this`.
	**/
	public function setOnComplete(callback: () -> Void): Timer {
		this.onCompleteCallback = callback;
		return this;
	}

	/**
		Clears the next `Timer` of `this`.
		@return `this`.
	**/
	public function clearNext(): Timer {
		this.next = Maybe.none();
		return this;
	}

	/**
		Sets the next `Timer` of `this`.
		@return `this`.
	**/
	public function setNext(timer: Timer): Timer {
		this.next = Maybe.from(timer);
		return this;
	}

	/**
		Clears the `Timers` instance to which `this` belongs.
		@return `this`.
	**/
	public function clearParent(): Timer {
		this.parent = Maybe.none();
		return this;
	}

	/**
		Sets the `Timers` instance to which `this` belongs.
		@return `this`.
	**/
	public function setParent(parent: Timers): Timer {
		this.parent = parent;
		return this;
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
		Returns a `DelayTimer` that precedes `this`.

		*Note that this does not return `this` itself.*
		@param pool If not provided, creates a new `DelayTimer` instance.
	**/
	public function delay(duration: UInt, ?pool: DelayTimerPool): DelayTimer {
		var delay: DelayTimer;
		if (pool != null) {
			delay = pool.use(duration);
		} else {
			delay = new DelayTimer();
			delay.setDuration(duration);
		}
		delay.setNext(this);
		return delay;
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
		@param progress The progress ratio in range `[0, 1)`.
	**/
	function onProgress(progress: Float): Void {}

	/**
		Called in `this.step()` if this timer is completed.
		Override this method for your own purpose.
	**/
	function onComplete(): Void {
		final parent = this.parent;
		final next = this.next;
		if (parent.isSome() && next.isSome()) parent.unwrap().push(next.unwrap());

		this.onCompleteCallback();
	}
}

@:access(broker.timer.builtin.heaps.Timer)
class TimerExtension {
	/**
		Resets variables of `this`.
		@return `this`.
	**/
	public static function reset(_this: Timer, duration: UInt): Timer {
		_this.setDuration(duration);
		_this.clearCallbacks();
		_this.clearNext();
		_this.clearParent();
		return _this;
	}
}
