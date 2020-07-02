package broker.scene.common;

import sneaker.exception.NotOverriddenException;
import broker.timer.Timer;
import broker.timer.Timers;
import broker.timer.builtin.SwitchSceneTimer;
import broker.color.ArgbColor;

/**
	Base class for `broker.scene.Scene`.
**/
class Scene {
	/**
		The stack to which `this` belongs.
	**/
	public var sceneStack: Maybe<SceneStack>;

	/**
		Drawing layers of `this` scene.
	**/
	public final layers: Layers;

	/**
		Timers attached to `this` scene.
	**/
	public final timers: Timers;

	/**
		`true` if active.

		Automatically set in `activate()`/`deactivate()`,
		but can also be set manually (e.g. set to `false` for preventing update).

		Does not affect `this.timers`.
	**/
	public var isActive: Bool;

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
		Returns the type id of `this`.
		Override this method for returning any user-defined value.
	**/
	public function getTypeId(): SceneTypeId
		return SceneTypeId.DEFAULT;

	/**
		Called when `this.activate()` is called for the first time.
	**/
	public function initialize(): Void {
		this.isInitialized = true;
	}

	/**
		Updates `this` scene.
	**/
	public function update(): Void {}

	/**
		Called in `SceneStack.update()` and does the below:
		- Calls `this.update()` if active.
		- Steps all `Timer` instances attached to `this`.
	**/
	public function step(): Void {
		if (this.isActive) this.update();
		this.timers.step();
	}

	/**
		Called when `this` scene becomes the top in the scene stack.
	**/
	public function activate(): Void {
		if (!this.isInitialized) this.initialize();
		this.isTransitioning = false;
		this.isActive = true;

		this.step(); // Update and step timers for the first frame after activating.
	}

	/**
		Called when `this` scene is no more the top in the scene stack but is not immediately destroyed.
	**/
	public function deactivate(): Void {
		this.isActive = false;
	}

	/**
		Destroys `this` scene.
	**/
	public function destroy(): Void {
		this.isActive = false;
	}

	/**
		Starts fade-in effect.
		@param color The starting color.
		@param duration The duration frame count.
		@param startNow If `true`, immediately adds the timer to `this`.
		@return A `Timer` instance.
	**/
	public function fadeInFrom(
		color: ArgbColor,
		duration: UInt,
		startNow: Bool
	): Timer
		throw new NotOverriddenException();

	/**
		Starts fade-out effect.
		@param color The ending color.
		@param duration The duration frame count.
		@param startNow If `true`, immediately adds the timer to `this`.
		@return A `Timer` instance.
	**/
	public function fadeOutTo(
		color: ArgbColor,
		duration: UInt,
		startNow: Bool
	): Timer
		throw new NotOverriddenException();

	/**
		Switches to the next scene.
		@param duration The delay duration frame count.
		@param startNow If `true`, immediately adds the timer to `this`.
		@return A `Timer` instance. `Maybe.none()` if `this` does not belong to any `SceneStack`.
	**/
	public function switchTo(
		nextScene: broker.scene.Scene,
		duration: UInt,
		destroy: Bool,
		startNow: Bool
	): Maybe<Timer> {
		final sceneStack = this.sceneStack;
		if (sceneStack.isNone()) return Maybe.none();

		final timer: Timer = SceneStatics.switchSceneTimerPool.use(
			duration,
			this,
			nextScene,
			sceneStack.unwrap(),
			destroy
		);

		if (startNow) this.timers.push(timer);

		return Maybe.from(timer);
	}

	/**
		@param timersCapacity The max number of `Timer` instances. Defaults to `16`.
	**/
	function new(layers: Layers, timersCapacity: UInt = 16) {
		this.isInitialized = false;
		this.sceneStack = Maybe.none();

		this.layers = layers;

		this.timers = new Timers(timersCapacity);
		this.isActive = false;
		this.isTransitioning = false;

		this.setTransitionState = SceneStatics.dummyCallback;
		this.unsetTransitionState = SceneStatics.dummyCallback;

		this.setTransitionState = () -> this.isTransitioning = true;
		this.unsetTransitionState = () -> this.isTransitioning = false;
	}
}

/**
	Static variables used in `Scene`.
**/
private class SceneStatics {
	/**
		Dummy empty function.
	**/
	public static final dummyCallback = () -> {};

	/**
		Object pool for `SwitchSceneTimer`.
	**/
	public static final switchSceneTimerPool = {
		final pool = new SwitchSceneTimerPool(4);
		pool.newTag("Scene SwitchSceneTimer pool");
		pool;
	}
}
