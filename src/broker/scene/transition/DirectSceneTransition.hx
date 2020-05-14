package broker.scene.transition;

/**
	Transition without any effect.
**/
@:structInit
class DirectSceneTransition extends SceneTransitionBase implements SceneTransition {
	public final delayDuration: UInt;
	public final destroy: Bool;

	/**
		@param destroy If `true`, destroys the old scene when switching.
	**/
	public function new(
		precedingSceneType: SceneTypeId,
		succeedingSceneType: SceneTypeId,
		delayDuration: UInt,
		destroy: Bool
	) {
		super(precedingSceneType, succeedingSceneType);
		this.delayDuration = delayDuration;
		this.destroy = destroy;
	}

	/**
		Runs transition from `currentScene` to `nextScene`.
	**/
	public function run(currentScene: Scene, nextScene: Scene): Void {
		currentScene.switchTo(nextScene, this.delayDuration, this.destroy);
	}
}
