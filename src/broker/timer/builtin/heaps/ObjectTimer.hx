package broker.timer.builtin.heaps;

#if heaps
import broker.timer.TimerBase;

class ObjectTimerTools {
	public static final dummyObjectCallback = function(object: Dynamic) {};
	public static final dummyOnProgressObjectCallback = function(
		object: Dynamic,
		progress: Float
	) {};
}

@:using(broker.timer.builtin.heaps.ObjectTimer.ObjectTimerExtension)
class ObjectTimer<T: h2d.Object> extends TimerBase {
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
		Function called on `this.object` in `this.onProgress()`.
	**/
	var onProgressObjectCallback: (object: T, progress: Float) -> Void;

	/**
		Function called on `this.object` in `this.onComplete()`.
	**/
	var onCompleteObjectCallback: (object: T) -> Void;

	function new() {
		super();
		this.onStartObjectCallback = ObjectTimerTools.dummyObjectCallback;
		this.onProgressObjectCallback = ObjectTimerTools.dummyOnProgressObjectCallback;
		this.onCompleteObjectCallback = ObjectTimerTools.dummyObjectCallback;
	}

	/**
		Clears callback functions of `this` timer.
		@return `this`.
	**/
	override public function clearCallbacks(): Timer {
		super.clearCallbacks();
		this.onStartObjectCallback = ObjectTimerTools.dummyObjectCallback;
		this.onProgressObjectCallback = ObjectTimerTools.dummyOnProgressObjectCallback;
		this.onCompleteObjectCallback = ObjectTimerTools.dummyObjectCallback;
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
		Sets `onProgressObject` callback function.
		@return `this`.
	**/
	public function setOnProgressObject(
		callback: (object: T, progress: Float) -> Void
	): ObjectTimer<T> {
		this.onProgressObjectCallback = callback;
		return this;
	}

	/**
		Sets `onCompleteObject` callback function.
		@return `this`.
	**/
	public function setOnCompleteObject(
		callback: (object: T) -> Void
	): ObjectTimer<T> {
		this.onCompleteObjectCallback = callback;
		return this;
	}

	override function onStart(): Void {
		super.onStart();
		this.onStartObjectCallback(this.object);
	}

	override function onProgress(progress: Float): Void {
		super.onProgress(progress);
		this.onProgressObjectCallback(this.object, progress);
	}

	override function onComplete(): Void {
		super.onComplete();
		this.onCompleteObjectCallback(this.object);
	}
}

@:access(broker.timer.builtin.heaps.ObjectTimer)
class ObjectTimerExtension {
	/**
		Resets variables of `this`.
		@return `this`.
	**/
	public static function reset<T: h2d.Object>(
		_this: ObjectTimer<T>,
		object: T,
		duration: UInt
	): ObjectTimer<T> {
		_this.object = object;
		_this.setDuration(duration);
		_this.clearCallbacks();
		_this.clearNext();
		_this.clearParent();
		return _this;
	}
}
#end
