package broker.scene.heaps;

#if heaps
import broker.timer.Timers;

/**
	Base class that implements `broker.scene.Scene` and internally contains a `h2d.Scene` instance.
	Requires `Scene.initialize()` to be called before creating any instance.
**/
class Scene implements broker.scene.Scene<Layer> {
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
		Background layer.
	**/
	public final background: Layer;

	/**
		Main layer.
	**/
	public final mainLayer: Layer;

	/**
		Surface layer.
	**/
	public final surface: Layer;

	/**
		Timers attached to `this` scene.
	**/
	public final timers: Timers;

	/**
		`h2d.Scene` instance to be wrapped.
	**/
	final heapsScene: h2d.Scene;

	/**
		@param heapsScene If not provided, creates a new one.
		@param timersCapacity The max number of `Timer` instances. Defaults to `16`.
	**/
	public function new(?heapsScene: h2d.Scene, ?timersCapacity: UInt) {
		final heapsScene = if (heapsScene != null) heapsScene else new h2d.Scene();

		this.background = new Layer(heapsScene);
		this.mainLayer = new Layer(heapsScene);
		this.surface = new Layer(heapsScene);

		this.timers = new Timers(Nulls.coalesce(timersCapacity, 16));

		this.heapsScene = heapsScene;
	}

	/**
		Updates `this` scene.
		Steps all `Timer` instances attached to `this`.
	**/
	public function update(): Void
		this.timers.step();

	/**
		Called when `this` scene becomes the top in the scene stack.
		Calls `setScene()` on the `hxd.App` instance.
	**/
	public function activate(): Void
		heapsApp.unwrap().setScene(this.heapsScene, false);

	/**
		Called when `this` scene is no more the top in the scene stack but is not immediately destroyed.
		Has no effect but can be overridden for your own purpose.
	**/
	public function deactivate(): Void {}

	/**
		Destroys `this` scene.
		Calls `dispose()` on the internal `h2d.Scene` instance.
	**/
	public function destroy(): Void
		this.heapsScene.dispose();
}
#end
