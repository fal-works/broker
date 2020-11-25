package broker.timer.builtin;

import broker.timer.Timer;
import broker.object.Object;

/**
	`Timer` that works on any `Object` instance.
**/
#if !broker_generic_disable
@:generic
#end
class ObjectTimer extends Timer {
	/**
		The object to which `this` timer refers.
	**/
	public var object(default, null): Object;

	/**
		Function called on `this.object` in `this.onStart()`.
	**/
	var onStartObjectCallback: (object: Object) -> Void;

	/**
		Function called on `this.object` in `this.onComplete()`.
	**/
	var onCompleteObjectCallback: (object: Object) -> Void;

	function new(object: Object) {
		super();
		this.object = object;
		this.onStartObjectCallback = ObjectTimerStatics.dummyObjectCallback;
		this.onCompleteObjectCallback = ObjectTimerStatics.dummyObjectCallback;
	}

	public function setObject(object: Object): ObjectTimer {
		this.object = object;
		return this;
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
	public function setOnStartObject(callback: (object: Object) -> Void): ObjectTimer {
		this.onStartObjectCallback = callback;
		return this;
	}

	/**
		Sets `onCompleteObject` callback function.
		@return `this`.
	**/
	public function setOnCompleteObject(callback: (object: Object) -> Void): ObjectTimer {
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
	public static final dummyObjectCallback = function(object: Object) {};
}
