package broker.timer;

interface Timer {
	/**
		Current progress rate. Is increased in `this.step()`.
	**/
	var progress: Float;

	/**
		Steps `this` timer.
		@return `true` if not completed (i.e. this timer should still be alive). Otherwise `false`.
	**/
	function step(): Bool;
}
