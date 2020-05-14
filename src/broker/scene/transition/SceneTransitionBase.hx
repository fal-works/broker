package broker.scene.transition;

/**
	Base class for other transition classes.
**/
class SceneTransitionBase {
	public final precedingSceneType: SceneTypeId;
	public final succeedingSceneType: SceneTypeId;

	function new(
		precedingSceneType: SceneTypeId,
		succeedingSceneType: SceneTypeId
	) {
		this.precedingSceneType = precedingSceneType;
		this.succeedingSceneType = succeedingSceneType;
	}

	public function hasSameKeys(other: SceneTransition): Bool {
		return this.precedingSceneType == other.precedingSceneType
			&& this.succeedingSceneType == other.succeedingSceneType;
	}
}
