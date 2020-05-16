package broker.scene.transition;

/**
	Data unit that determines transition effect between any two types of scenes.
**/
interface SceneTransition {
	/**
		The type ID of the preceding scene.
	**/
	final precedingSceneType: SceneTypeId;

	/**
		The type ID of the succeeding scene.
	**/
	final succeedingSceneType: SceneTypeId;

	/**
		Runs transition from `currentScene` to `nextScene`.
		Has no effect if any transition from `currentScene` is already running.
	**/
	function run(currentScene: Scene, nextScene: Scene): Void;

	/**
		@return `true` if `this` and `other` have the same keys.
	**/
	function hasSameKeys(other: SceneTransition): Bool;
}
