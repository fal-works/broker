package broker;

/**
	The whole application.
**/
class App {
	/**
		Total frame count elapsed.
	**/
	public static var frameCount = UInt.zero;

	/**
		The logical width of the screen.
	**/
	@:nullSafety(Off)
	public static var width(default, null): UInt;

	/**
		The logical height of the screen.
	**/
	@:nullSafety(Off)
	public static var height(default, null): UInt;

	/**
		The underlying application instance.
	**/
	@:nullSafety(Off)
	public static var data: #if heaps hxd.App #else Dynamic #end;

	/**
		Called if `broker.App` catches any `haxe.Exception`.
		The exception will be rethrown unless you quits the application.
	**/
	public static var onException = (e: haxe.Exception) -> {};

	/**
		Called if `broker.App` catches any exception other than `haxe.Exception`.
		The exception will be rethrown unless you quits the application.
	**/
	public static var onUnknownException = (e: Dynamic) -> {};

	/**
		Adds `object` to the current scene.
	**/
	public static function addRootObject(object: broker.object.Object): Void {
		#if heaps
		data.s2d.addChild(object);
		#end
	}

	/**
		Automatically called if `broker.App` catches any exception (whether or not `haxe.Exception`).
	**/
	static function onAnyExceptionInternal(): Void {
		broker.tools.Window.fullscreen = false;
		broker.sound.SoundManager.disposeAll();
	}

	/**
		If `true`, sets the window to fullscreen in `initializeInternal()`.
	**/
	final startFullscreen: Bool;

	/**
		@param width The logical width of the screen.
		@param height The logical height of the screen.
	**/
	public function new(width: UInt, height: UInt, fullscreen = true) {
		App.width = width;
		App.height = height;
		this.startFullscreen = fullscreen;

		#if heaps
		data = new HeapsApp(this);
		#end
	}

	/**
		Override this and write your initialization process.
	**/
	function initialize(): Void {}

	/**
		Override this and write your updating process.
	**/
	function update(): Void {}

	/**
		Automatically called before `initialize()`.
	**/
	@:access(broker.tools.Window)
	@:access(broker.input.physical.Key)
	@:access(broker.input.physical.Pad)
	inline function initializeInternal(): Void {
		broker.tools.Window.initialize(this.startFullscreen);
		broker.input.physical.Key.initialize();
		broker.input.physical.Pad.initialize();

		#if heaps
		broker.scene.heaps.Scene.setApplication(data);
		#end

		new broker.scene.Scene().activate();
	}

	/**
		Automatically called after `update()`.
	**/
	@:access(broker.sound.SoundManager)
	@:access(broker.tools.Gc)
	inline function updateInternal(): Void {
		++frameCount;
		broker.sound.SoundManager.update();
		broker.tools.Gc.update();
	}
}

#if heaps
@:access(broker.App)
class HeapsApp extends hxd.App {
	final app: App;

	public function new(app: App) {
		super();
		this.app = app;
	}

	override function init() {
		app.initializeInternal();

		#if broker_catch_disable
		app.initialize();
		#else
		try {
			app.initialize();
		} catch(e: haxe.Exception) {
			App.onAnyExceptionInternal();
			App.onException(e);
			throw e;
		} catch(e: Dynamic) {
			App.onAnyExceptionInternal();
			App.onUnknownException(e);
			throw e;
		}
		#end
	}

	override function update(dt: Float) {
		#if broker_catch_disable
		app.update();
		#else
		try {
			app.update();
		}	catch(e: haxe.Exception) {
			App.onAnyExceptionInternal();
			App.onException(e);
			throw e;
		} catch(e: Dynamic) {
			App.onAnyExceptionInternal();
			App.onUnknownException(e);
			throw e;
		}
		#end

		app.updateInternal();
	}
}
#end
