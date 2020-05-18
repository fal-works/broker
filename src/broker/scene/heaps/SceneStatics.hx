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
	public static var bitmapPool(default, null): SafeObjectPool<h2d.Object> = null;

	/**
		Object pool for `FadeInTimer`.
	**/
	public static final fadeInTimerPool = {
		final pool = new FadeInTimerPool(4);
		pool.newTag("Scene FadeInTimer pool");
		pool;
	}

	/**
		Object pool for `FadeOutTimer`.
	**/
	public static final fadeOutTimerPool = {
		final pool = new FadeOutTimerPool(4);
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

	public static function setApplication(app: hxd.App) {
		heapsApp = app;

		final pool = new SafeObjectPool<h2d.Object>(
			4,
			() -> new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF))
		);
		pool.newTag("Scene Bitmap pool");
		bitmapPool = pool;
	}
}
#end
