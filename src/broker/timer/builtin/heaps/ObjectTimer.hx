package broker.timer.builtin.heaps;

#if heaps
import broker.timer.Timer;

/**
	`Timer` that works on any `h2d.Object` instance.
**/
	#if !broker_generic_disable
	@:generic
	#end
class ObjectTimer<T:h2d.Object> extends Timer {
	/**
		The object to which `this` timer refers.
	**/
	@:nullSafety(Off)
	public var object(default, null): T = null;

	/**
		Function called on `this.object` in `this.onStart()`.
	**/
	var onStartObjectCallback: (object: T) -> Void;

	/**
		Function called on `this.object` in `this.onComplete()`.
	**/
	var onCompleteObjectCallback: (object: T) -> Void;

	function new() {
		super();
		this.onStartObjectCallback = ObjectTimerStatics.dummyObjectCallback;
		this.onCompleteObjectCallback = ObjectTimerStatics.dummyObjectCallback;
	}

	/**
		Clears callback functions of `this` timer.
		@return `this`.
	**/
	override public function clearCallbacks(): Timer {
		super.clearCallbacks();
		this.onStartObjectCallback = ObjectTimerStatics.dummyObjectCallback;
		this.onCompleteObjectCallback = ObjectTimerStatics.dummyObjectCallback;
		return this;
	}

	/**
		Sets `onStartObject` callback function.
		@return `this`.
	**/
	public function setOnStartObject(callback: (object: T) -> Void): ObjectTimer<T> {
		this.onStartObjectCallback = callback;
		return this;
	}

	/**
		Sets `onCompleteObject` callback function.
		@return `this`.
	**/
	public function setOnCompleteObject(callback: (object: T) -> Void): ObjectTimer<T> {
		this.onCompleteObjectCallback = callback;
		return this;
	}

	override function onStart(): Void {
		super.onStart();
		this.onStartObjectCallback(this.object);
	}

	override function onComplete(): Void {
		super.onComplete();
		this.onCompleteObjectCallback(this.object);
	}
}

private class ObjectTimerStatics {
	public static final dummyObjectCallback = function(object: Dynamic) {};
}
#end
