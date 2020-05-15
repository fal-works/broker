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
		destroy: Bool,
		?onStart: () -> Void,
		?onProgress: (progress: Float) -> Void,
		?onComplete: () -> Void
	): SwitchSceneTimer {
		final timer = pool.get();
		timer.reset(duration, nextScene, sceneStack, destroy, onStart, onProgress, onComplete);
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

	public function new() {
		super();
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
		destroy: Bool,
		?onStart: () -> Void,
		?onProgress: (progress: Float) -> Void,
		?onComplete: () -> Void
	): Void {
		this.setDuration(duration);
		this.setCallbacks(onStart, onProgress, onComplete);
		this.nextScene = nextScene;
		this.sceneStack = sceneStack;
	}

	override public function onComplete(): Void {
		super.onComplete();
		final nextScene = this.nextScene.unwrap();
		this.sceneStack.unwrap().switchTop(nextScene, this.destroy);
		pool.put(this);
	}
}
