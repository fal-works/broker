package broker.scene.transition;

/**
	Data unit that determines transition effect between any two types of scenes.
**/
@:structInit
@:ripper_verified
class SceneTransitionRecord implements ripper.Data {
	/**
		The type ID of the preceding scene.
	**/
	public final precedingType: SceneTypeId;

	/**
		The type ID of the succeeding scene.
	**/
	public final succeedingType: SceneTypeId;

	/**
		The transition that should be run when switching scenes
		from `precedingType` to `succeedingType`.
	**/
	public final transition: SceneTransition;

	/**
		@return `true` if `this` and `other` have the same keys.
	**/
	public function hasSameKeys(other: SceneTransitionRecord): Bool {
		return this.precedingType == other.precedingType
			&& this.succeedingType == other.succeedingType;
	}
}
