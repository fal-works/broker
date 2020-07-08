package broker;

/**
	Static fields related to the whole application.
**/
class App {
	/**
		Total frame count elapsed.
	**/
	public static var frameCount = UInt.zero;

	/**
		The logical width of the screen.
	**/
	public static var width(default, null): UInt = 0;

	/**
		The logical height of the screen.
	**/
	public static var height(default, null): UInt = 0;

	/**
		Initializes `broker` features.

		If using Heaps, you should call `initializeHeaps()` as well.
	**/
	public static function initialize(width: UInt, height: UInt): Void {
		App.width = width;
		App.height = height;

		broker.tools.Window.initialize();
		broker.input.physical.PhysicalInput.initialize();
	}

	#if heaps
	/**
		Initializes heaps-related features.
	**/
	public static function initializeHeaps(app: hxd.App): Void {
		broker.scene.heaps.Scene.setApplication(app);
	}
	#end

	/**
		Increments `frameCount`.
		Call this method every frame.
	**/
	public static inline function tick(): Void {
		++frameCount;
	}
}
