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
		Adds `object` to the current scene.
	**/
	public static function addRootObject(object: broker.object.Object): Void {
		#if heaps
		data.s2d.addChild(object);
		#end
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

		try {
			app.initialize();
		} catch(e: Dynamic) {
			broker.tools.Window.fullscreen = false;
			throw e;
		}
	}

	override function update(dt: Float) {
		try {
			app.update();
		}	catch(e: Dynamic) {
			broker.tools.Window.fullscreen = false;
			throw e;
		}

		app.updateInternal();
	}
}
#end
