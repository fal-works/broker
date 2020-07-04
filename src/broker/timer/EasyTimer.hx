package broker.timer;

/**
	Handy extension of `Timer`.
	You can set `onProgress` callback so that you don't need to define a new class extending from `Timer`.
**/
@:structInit
class EasyTimer extends Timer {
	static final dummyOnProgress = (_: Float) -> {};

	/**
		Function called in `this.onProgress()`.
	**/
	var onProgressCallback: Float -> Void;

	public function new(
		?duration: UInt,
		?onStart: () -> Void,
		?onProgress: (progress: Float) -> Void,
		?onComplete: () -> Void
	) {
		super(duration, onStart, onComplete);
		this.onProgressCallback = Nulls.coalesce(onProgress, dummyOnProgress);
	}

	override function onProgress(progress: Float): Void
		this.onProgressCallback(progress);

	/**
		Sets `onProgress` callback function.
		@return `this`.
	**/
	public function setOnProgress(callback: (progress: Float) -> Void): EasyTimer {
		this.onProgressCallback = callback;
		return this;
	}
}
