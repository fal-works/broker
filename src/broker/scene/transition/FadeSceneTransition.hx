package broker.scene.transition;

import broker.color.ArgbColor;

/**
	Transition with fade-out/fade-in effects.
**/
@:structInit
class FadeSceneTransition extends SceneTransitionBase implements SceneTransition {
	public final color: ArgbColor;
	public final fadeOutDuration: UInt;
	public final intervalDuration: UInt;
	public final fadeInDuration: UInt;
	public final destroy: Bool;

	/**
		@param destroy If `true`, destroys the old scene when switching.
	**/
	public function new(
		precedingSceneType: SceneTypeId,
		succeedingSceneType: SceneTypeId,
		color: ArgbColor,
		fadeOutDuration: UInt,
		intervalDuration: UInt,
		fadeInDuration: UInt,
		destroy: Bool
	) {
		super(precedingSceneType, succeedingSceneType);
		this.color = color;
		this.fadeOutDuration = fadeOutDuration;
		this.intervalDuration = intervalDuration;
		this.fadeInDuration = fadeInDuration;
		this.destroy = destroy;
	}

	/**
		Runs transition from `currentScene` to `nextScene`.
		Has no effect if `currentScene` does not belong to any `SceneStack`
		or any transition from `currentScene` is already running.
	**/
	public function run(currentScene: Scene, nextScene: Scene): Void {
		if (currentScene.isTransitioning) return;

		final switchScene = currentScene.switchTo(
			nextScene,
			this.intervalDuration,
			this.destroy,
			false
		);
		if (switchScene.isNone()) return;

		final fadeCurrentScene = currentScene.fadeOutTo(
			this.color,
			this.fadeOutDuration,
			true
		);
		fadeCurrentScene.setNext(switchScene.unwrap());

		final fadeNextScene = nextScene.fadeInFrom(
			this.color,
			this.fadeInDuration,
			true
		);
		fadeNextScene.setOnComplete(nextScene.unsetTransitionState);

		currentScene.isTransitioning = true;
		nextScene.isTransitioning = true;
	}
}
