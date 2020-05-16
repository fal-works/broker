package broker.scene.heaps;

#if heaps
import broker.timer.Timer;
import broker.timer.Timers;
import broker.timer.builtin.FadeInTimer;
import broker.timer.builtin.FadeOutTimer;
import broker.timer.builtin.SwitchSceneTimer;
import broker.color.ArgbColor;

/**
	Base class that implements `broker.scene.Scene` and internally contains a `h2d.Scene` instance.
	Requires `Scene.initialize()` to be called before creating any instance.
**/
class Scene implements broker.scene.Scene {
	/**
		The `hxd.App` instance to pass `heapsScene` of any `Scene` instance.
	**/
	static var heapsApp: Maybe<hxd.App> = Maybe.none();

	/**
		Dummy empty function.
	**/
	static final dummyCallback = () -> {};

	/**
		Registers the `hxd.App` instance.
	**/
	public static function setApplication(app: hxd.App): Void {
		heapsApp = app;
	}

	/**
		The stack to which `this` belongs.
	**/
	public var sceneStack: Maybe<broker.scene.SceneStack>;

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
		`true` if any scene transition is running.
	**/
	public var isTransitioning: Bool;

	/**
		Callback function for running `this.isTransitioning = true`.
	**/
	public final setTransitionState: () -> Void;

	/**
		Callback function for running `this.isTransitioning = false`.
	**/
	public final unsetTransitionState: () -> Void;

	/**
		`true` if `this.initialize()` is already called.
	**/
	var isInitialized: Bool;

	/**
		`h2d.Scene` instance to be wrapped.
	**/
	final heapsScene: h2d.Scene;

	/**
		Internal bitmap used for fade-in/fade-out effects.
	**/
	final surfaceBitmap = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF));

	/**
		@param heapsScene If not provided, creates a new one.
		@param timersCapacity The max number of `Timer` instances. Defaults to `16`.
	**/
	public function new(?heapsScene: h2d.Scene, ?timersCapacity: UInt) {
		this.isInitialized = false;
		this.sceneStack = Maybe.none();

		final heapsScene = if (heapsScene != null) heapsScene else new h2d.Scene();

		this.background = new Layer(heapsScene);
		this.mainLayer = new Layer(heapsScene);
		this.surface = new Layer(heapsScene);

		this.timers = new Timers(Nulls.coalesce(timersCapacity, 16));
		this.isTransitioning = false;

		this.heapsScene = heapsScene;

		this.setTransitionState = dummyCallback;
		this.unsetTransitionState = dummyCallback;

		this.setTransitionState = () -> this.isTransitioning = true;
		this.unsetTransitionState = () -> this.isTransitioning = false;
	}

	/**
		Returns the type id of `this`.
		Override this method for returning any user-defined value.
	**/
	public function getTypeId(): SceneTypeId
		return SceneTypeId.DEFAULT;

	/**
		Called when `this.activate()` is called for the first time.
		Can be overridden for your own purpose.
	**/
	public function initialize(): Void {
		this.isInitialized = true;
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
	public function activate(): Void {
		if (!this.isInitialized) this.initialize();
		this.isTransitioning = false;
		heapsApp.unwrap().setScene(this.heapsScene, false);
	}

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

	/**
		Starts fade-in effect.
		@param color The starting color.
		@param duration The duration frame count.
		@return A `Timer` instance.
	**/
	public function fadeInFrom(
		color: ArgbColor,
		duration: Int
	): Timer {
		final bitmap = this.setSurfaceBitmap(color);

		// (fade-in the scene) = (fade-out the surface)
		final timer = FadeOutTimer.use(
			bitmap,
			duration,
			true
		);
		this.timers.push(timer);
		return timer;
	}

	/**
		Starts fade-out effect.
		@param color The ending color.
		@param duration The duration frame count.
		@return A `Timer` instance.
	**/
	public function fadeOutTo(
		color: ArgbColor,
		duration: Int
	): Timer {
		final bitmap = this.setSurfaceBitmap(color);

		// (fade-out the scene) = (fade-in the surface)
		final timer = FadeInTimer.use(
			bitmap,
			duration
		);
		this.timers.push(timer);
		return timer;
	}

	/**
		Switches to the next scene.
		Has no effect if any transition is already running.
		@param duration The delay duration frame count.
		@return A `Timer` instance.
	**/
	public function switchTo(
		nextScene: broker.scene.Scene,
		duration: Int,
		destroy: Bool
	): Maybe<Timer> {
		if (this.isTransitioning) return Maybe.none();
		this.isTransitioning = true;

		final sceneStack = this.sceneStack.unwrap();
		final timer: Timer = SwitchSceneTimer.use(
			duration,
			this,
			nextScene,
			sceneStack,
			destroy
		);
		this.timers.push(timer);
		return Maybe.from(timer);
	}

	/**
		Resets `this.surfaceBitmap` with `color` and adds it to `this` scene.
		@return `this.surfaceBitmap`.
	**/
	function setSurfaceBitmap(color: ArgbColor): h2d.Bitmap {
		final bitmap = this.resetCoverBitmap(this.surfaceBitmap, color);
		this.surface.heapsObject.addChild(bitmap);
		return bitmap;
	}

	/**
		Resets `bitmap` so that it covers the entire area of `this` scene with `color`.
	**/
	@:access(h2d.Tile)
	function resetCoverBitmap(bitmap: h2d.Bitmap, color: ArgbColor): h2d.Bitmap {
		@:nullSafety(Off)
		final texture: h3d.mat.Texture = h3d.mat.Texture.fromColor(
			color.getRGB().int(),
			color.getAlpha().float()
		);

		final tile = bitmap.tile;
		tile.setTexture(texture);

		final heapsScene = this.heapsScene;
		tile.setSize(heapsScene.width, heapsScene.height);

		return bitmap;
	}

	static function createTransitionStateCallback(scene: Scene, value: Bool): () -> Void {
		return if (value) function() {
			scene.isTransitioning = true;
		} else function() {
			scene.isTransitioning = false;
		};
	}
}
#end
