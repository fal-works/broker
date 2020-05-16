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

	/**
		Clears the next `Timer` of `this`.
		@return `this`.
	**/
	public function clearNext(): Timer;

	/**
		Sets the next `Timer` of `this`.
		@return `this`.
	**/
	public function setNext(timer: Timer): Timer;

	/**
		Clears the `Timers` instance to which `this` belongs.
		@return `this`.
	**/
	public function clearParent(): Timer;

	/**
		Sets the `Timers` instance to which `this` belongs.
		@return `this`.
	**/
	public function setParent(parent: Timers): Timer;
}
