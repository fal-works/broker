package broker.scene.transition;

/**
	Transition without any effect.
**/
@:structInit
@:ripper_verified
class DirectSceneTransition implements SceneTransition implements ripper.Data {
	public final delayDuration: UInt;
	public final destroy: Bool;

	/**
		@param destroy If `true`, destroys the old scene when switching.
	**/
	public function new() {}

	/**
		Runs transition from `currentScene` to `nextScene`.
		Has no effect if any transition from `currentScene` is already running.
	**/
	public function run(currentScene: Scene, nextScene: Scene): Void {
		if (currentScene.isTransitioning) return;
		currentScene.switchTo(nextScene, this.delayDuration, this.destroy, true);
	}
}
