package broker.scene.heaps;

#if heaps
import broker.App;
import broker.timer.Timer;
import broker.color.ArgbColor;
import broker.scene.internal.Scene as SceneBase;

/**
	Base class for `broker.scene.Scene` that internally contains a `h2d.Scene` instance.
	Requires `Scene.setApplication()` to be called before creating any instance.
**/
class Scene extends SceneBase {
	/**
		Registers the `hxd.App` instance.
	**/
	public static function setApplication(app: hxd.App): Void
		SceneStatics.setApplication(app);

	/**
		@param heapsScene If not provided, creates a new one.
		@param timersCapacity The max number of `Timer` instances. Defaults to `16`.
	**/
	public function new(?heapsScene: h2d.Scene, ?timersCapacity: UInt) {
		final hScene = if (heapsScene != null) heapsScene else new h2d.Scene();
		hScene.defaultSmooth = true;
		hScene.scaleMode = LetterBox(App.width, App.height);

		final layers = new Layers();

		super(hScene, layers, timersCapacity);

		final mask = new h2d.Mask(App.width, App.height, hScene);
		layers.addTo(mask);
	}

	/**
		Called when `this` scene becomes the top in the scene stack.
		Calls `setScene()` on the `hxd.App` instance.
	**/
	override public function activate(): Void {
		super.activate();
		SceneStatics.heapsApp.setScene(this.data, false);
	}

	/**
		Destroys `this` scene.
		Calls `dispose()` on the internal `h2d.Scene` instance.
	**/
	override public function destroy(): Void {
		super.destroy();
		this.data.dispose();
	}

	/**
		Starts fade-in effect.
		@param color The starting color.
		@param duration The duration frame count.
		@param startNow If `true`, immediately adds the timer to `this`.
		@return A `Timer` instance.
	**/
	override public function fadeInFrom(
		color: ArgbColor,
		duration: UInt,
		startNow: Bool
	): Timer {
		final bitmap = this.useSurfaceBitmap(color);
		bitmap.alpha = 0.0;

		// (fade-in the scene) = (fade-out the surface)
		final timer = SceneStatics.bitmapFadeOutTimerPool.use(
			bitmap,
			duration,
			true
		);
		timer.setOnCompleteObject(SceneStatics.bitmapPool.putCallback);

		if (startNow) this.timers.push(timer);

		return timer;
	}

	/**
		Starts fade-out effect.
		@param color The ending color.
		@param duration The duration frame count.
		@param startNow If `true`, immediately adds the timer to `this`.
		@return A `Timer` instance.
	**/
	override public function fadeOutTo(
		color: ArgbColor,
		duration: UInt,
		startNow: Bool
	): Timer {
		final bitmap = this.useSurfaceBitmap(color);
		bitmap.alpha = 0.0;

		// (fade-out the scene) = (fade-in the surface)
		final timer = SceneStatics.bitmapFadeInTimerPool.use(bitmap, duration);
		timer.setOnCompleteObject(SceneStatics.bitmapPool.putCallback);

		if (startNow) this.timers.push(timer);

		return timer;
	}

	/**
		Uses a bitmap from `bitmapPool`, resets it with `color` and adds it to the surface layer.
		@return `h2d.Bitmap` instance.
	**/
	function useSurfaceBitmap(color: ArgbColor): h2d.Bitmap {
		final bitmap = this.resetCoverBitmap(SceneStatics.bitmapPool.get(), color);
		this.layers.surface.add(bitmap);
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

		final heapsScene = this.data;
		tile.setSize(heapsScene.width, heapsScene.height);

		return bitmap;
	}
}
#end
