package broker.timer;

interface Timer {
	/**
		Current progress rate. Is increased in `this.step()`.
	**/
	var progress: Float;

	/**
		Steps `this` timer.
		@return `true` if completed. Otherwise `false`.
	**/
	function step(): Bool;
}
