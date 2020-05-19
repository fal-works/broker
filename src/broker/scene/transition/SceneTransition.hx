package broker.scene.transition;

/**
	Scene transition effect.
**/
interface SceneTransition {
	/**
		Runs transition from `currentScene` to `nextScene`.
		Has no effect if any transition from `currentScene` is already running.
	**/
	function run(currentScene: Scene, nextScene: Scene): Void;
}
