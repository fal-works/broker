package broker.scene.heaps;

#if heaps
import banker.pool.SafeObjectPool;
import broker.timer.builtin.SwitchSceneTimer;
import broker.timer.builtin.heaps.FadeInTimer;
import broker.timer.builtin.heaps.FadeOutTimer;

/**
	Static variables used in `Scene`.
**/
class SceneStatics {
	/**
		The `hxd.App` instance to pass `heapsScene` of any `Scene` instance.
	**/
	@:nullSafety(Off)
	public static var heapsApp: hxd.App = null;

	/**
		Dummy empty function.
	**/
	public static final dummyCallback = () -> {};

	/**
		Object pool for `Bitmap`.
	**/
	@:nullSafety(Off)
	public static var bitmapPool(default, null): SafeObjectPool<h2d.Bitmap> = null;

	/**
		Object pool for `FadeInTimer<Bitmap>`.
	**/
	public static final bitmapFadeInTimerPool = {
		final pool = new FadeInTimerPool<h2d.Bitmap>(4);
		pool.newTag("Scene FadeInTimer pool");
		pool;
	}

	/**
		Object pool for `FadeOutTimer<Bitmap>`.
	**/
	public static final bitmapFadeOutTimerPool = {
		final pool = new FadeOutTimerPool<h2d.Bitmap>(4);
		pool.newTag("Scene FadeOutTimer pool");
		pool;
	}

	/**
		Object pool for `SwitchSceneTimer`.
	**/
	public static final switchSceneTimerPool = {
		final pool = new SwitchSceneTimerPool(4);
		pool.newTag("Scene SwitchSceneTimer pool");
		pool;
	}

	/**
		Sets `hxd.App` instance.
		This method must be called before using the class `broker.scene.heaps.Scene`.
	**/
	public static function setApplication(app: hxd.App) {
		heapsApp = app;

		final pool = new SafeObjectPool(
			4,
			() -> new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF))
		);
		pool.newTag("Scene Bitmap pool");
		bitmapPool = pool;
	}
}
#end
