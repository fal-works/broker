package broker.scene.heaps;

#if heaps
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
	public static var heapsApp: Maybe<hxd.App> = Maybe.none();

	/**
		Dummy empty function.
	**/
	public static final dummyCallback = () -> {};

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
}
#end
