package broker.timer.builtin;

import banker.pool.SafeObjectPool;
import broker.scene.Scene;
import broker.scene.SceneStack;
import broker.timer.TimerBase;

class SwitchSceneTimer extends TimerBase {
	/**
		Object pool for `SwitchSceneTimer`.
	**/
	public static final pool = {
		final pool = new SafeObjectPool(UInt.one, () -> new SwitchSceneTimer());
		pool.newTag("SwitchSceneTimer pool");
		pool;
	}

	/**
		Returns a `SwitchSceneTimer` instance that is currently not in use.

		The instance is automatically recycled when completed so that it can be reused again
		(so `step()` should not be called again after completing).

		@return A `SwitchSceneTimer` instance.
	**/
	public static function use(
		duration: UInt,
		nextScene: Scene,
		sceneStack: SceneStack,
		destroy: Bool
	): SwitchSceneTimer {
		final timer = pool.get();
		timer.reset(duration, nextScene, sceneStack, destroy);
		return timer;
	}

	/**
		The next scene to start when `this` timer is completed.
	**/
	var nextScene: Maybe<Scene>;

	/**
		The scene stack that is holding the current scene.
	**/
	var sceneStack: Maybe<SceneStack>;

	/**
		If `true`, destroys the old scene when switching.
	**/
	var destroy: Bool;

	public function new(?duration: UInt) {
		super(duration);
		this.nextScene = Maybe.none();
		this.sceneStack = Maybe.none();
		this.destroy = false;
	}

	/**
		Resets variables of `this`.
	**/
	public function reset(
		duration: UInt,
		nextScene: Scene,
		sceneStack: SceneStack,
		destroy: Bool
	): Void {
		this.setDuration(duration);
		this.nextScene = nextScene;
		this.sceneStack = sceneStack;
	}

	override public function onComplete(): Void {
		final nextScene = this.nextScene.unwrap();
		this.sceneStack.unwrap().switchTop(nextScene, this.destroy);
		pool.put(this);
	}
}
