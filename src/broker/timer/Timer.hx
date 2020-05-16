package broker.timer;

interface Timer {
	/**
		Steps `this` timer.
		@return `true` if completed. Otherwise `false`.
	**/
	function step(): Bool;

	/**
		Clears callback functions of `this` timer.
		@return `this`.
	**/
	function clearCallbacks(): Timer;

	/**
		Sets `onStart` callback function.
		@return `this`.
	**/
	public function setOnStart(callback: () -> Void): Timer;

	/**
		Sets `onProgress` callback function.
		@return `this`.
	**/
	public function setOnProgress(callback: (progress: Float) -> Void): Timer;

	/**
		Sets `onComplete` callback function.
		@return `this`.
	**/
	public function setOnComplete(callback: () -> Void): Timer;
}
