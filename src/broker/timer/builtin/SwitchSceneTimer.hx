package broker.timer.builtin;

import banker.pool.interfaces.ObjectPool;
import banker.pool.SafeObjectPool;
import broker.scene.Scene;
import broker.scene.SceneStack;
import broker.timer.Timer;

/**
	`Timer` that switches the game scene when completed.
**/
class SwitchSceneTimer extends Timer {
	/**
		The current scene.
	**/
	public var currentScene: Maybe<Scene>;

	/**
		The next scene to start when `this` timer is completed.
	**/
	public var nextScene: Maybe<Scene>;

	/**
		The scene stack that is holding the current scene.
	**/
	public var sceneStack: Maybe<SceneStack>;

	/**
		If `true`, destroys the old scene when switching.
	**/
	public var destroy: Bool;

	public function new() {
		super();
		this.currentScene = Maybe.none();
		this.nextScene = Maybe.none();
		this.sceneStack = Maybe.none();
		this.destroy = false;
	}

	override function onStart(): Void {
		super.onStart();
		this.currentScene.unwrap().isTransitioning = true;
	}

	override function onComplete(): Void {
		super.onComplete();
		final nextScene = this.nextScene.unwrap();
		this.sceneStack.unwrap().switchTop(nextScene, this.destroy);
		this.currentScene.unwrap().isTransitioning = false;
	}
}

/**
	Extended `SwitchSceneTimer` that is automatically recycled when completed.
**/
final class PooledSwitchSceneTimer extends SwitchSceneTimer {
	/**
		The object pool to which `this` belongs.
	**/
	var pool: ObjectPool<PooledSwitchSceneTimer>;

	public function new(pool: ObjectPool<PooledSwitchSceneTimer>) {
		super();
		this.pool = pool;
	}

	override function onComplete(): Void {
		super.onComplete();
		this.pool.put(this);
	}
}

class SwitchSceneTimerPool extends SafeObjectPool<PooledSwitchSceneTimer> {
	public function new(capacity: UInt) {
		super(capacity, () -> new PooledSwitchSceneTimer(this));
	}

	/**
		This operation is not supported. Call `use()` instead.
	**/
	override public function get(): PooledSwitchSceneTimer {
		throw "Not implemented. Call use() instead of get().";
	}

	/**
		Gets a `PooledSwitchSceneTimer` instance that is currently not in use,
		and also resets some variables. Use this method instead of `get()`.

		The instance is automatically recycled when completed so that it can be reused again
		(so `step()` should not be called again after completing).

		@param duration The delay duration frame count.
		@return A `PooledSwitchSceneTimer` instance.
	**/
	@:access(broker.timer.builtin.PooledSwitchSceneTimer)
	public function use(
		duration: UInt,
		currentScene: Scene,
		nextScene: Scene,
		sceneStack: SceneStack,
		destroy: Bool
	): PooledSwitchSceneTimer {
		final timer = super.get();
		TimerExtension.reset(timer, duration);
		timer.currentScene = currentScene;
		timer.nextScene = nextScene;
		timer.sceneStack = sceneStack;
		timer.destroy = destroy;
		timer.pool = this;
		return timer;
	}
}
