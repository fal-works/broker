package broker.timer.builtin;

import broker.timer.Timer;
import broker.timer.TimerBase;

class FadeTimerBase extends TimerBase {
	/**
		Dummy object to be assigned when insantiating a timer.
	**/
	static final dummyObject = new h2d.Object();

	/**
		The object to change the alpha value.
	**/
	var object: h2d.Object;

	/**
		If `true`, calls `object.remove()` when completing.
	**/
	var removeOnComplete: Bool;

	function new() {
		super();
		this.object = dummyObject;
		this.removeOnComplete = true;
	}

	/**
		Resets variables of `this`.
	**/
	function reset(
		object: h2d.Object,
		duration: UInt,
		removeOnComplete: Bool
	): Void {
		this.object = object;
		this.setDuration(duration);
		this.removeOnComplete = removeOnComplete;
	}
}
