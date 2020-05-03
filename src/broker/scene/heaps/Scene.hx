package broker.scene.heaps;

#if heaps
/**
	Base class that implements `broker.scene.Scene` and internally contains a `h2d.Scene` instance.
	Requires `Scene.initialize()` to be called before creating any instance.
**/
class Scene extends broker.scene.Scene {
	/**
		The `hxd.App` instance to pass `heapsScene` of any `Scene` instance.
	**/
	static var heapsApp: Maybe<hxd.App> = Maybe.none();

	/**
		Registeres the `hxd.App` instance.
	**/
	public static function initialize(app: hxd.App): Void {
		heapsApp = app;
	}

	/**
		`h2d.Scene` instance to be wrapped.
	**/
	final heapsScene: h2d.Scene;

	/**
		@param heapsScene If not provided, creates a new one.
	**/
	public function new(?heapsScene: h2d.Scene) {
		this.heapsScene = if (heapsScene != null) heapsScene else new h2d.Scene();
	}

	/**
		Calls `setScene()` on the `hxd.App` instance.
	**/
	override public function activate(): Void
		heapsApp.unwrap().setScene(this.heapsScene, false);

	/**
		Calls `dispose()` on the internal `h2d.Scene` instance.
	**/
	override public function destroy(): Void
		this.heapsScene.dispose();
}
#end
