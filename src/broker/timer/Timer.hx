package broker.timer;

interface Timer {
	/**
		Steps `this` timer.
		@return `true` if completed. Otherwise `false`.
	**/
	function step(): Bool;
}
