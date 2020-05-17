package broker.timer.builtin.heaps;

#if heaps
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

	function new() {
		super();
		this.object = dummyObject;
	}

	/**
		Resets variables of `this`.
	**/
	public function reset(object: h2d.Object, duration: UInt): Void {
		this.object = object;
		this.setDuration(duration);
		this.clearCallbacks();
		this.clearNext();
		this.clearParent();
	}
}
#end
