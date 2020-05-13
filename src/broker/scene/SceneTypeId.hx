package broker.scene;

/**
	Identifier number for categorizing `Scene` instances.
**/
abstract SceneTypeId(Int) {
	/**
		The default id used for `Scene` base classes (such as `broker.scene.heaps.Scene`).
	**/
	public static extern inline final DEFAULT: SceneTypeId = new SceneTypeId(-1);

	/**
		A special `SceneTypeId` value that works as a wildcard.
	**/
	public static extern inline final ALL: SceneTypeId = new SceneTypeId(-2);

	/**
		Casts `value` to `SceneTypeId`.
	**/
	@:from public static extern inline function from(value: UInt): SceneTypeId {
		return new SceneTypeId(value);
	}

	@:op(A == B) function equals(other: SceneTypeId): Bool;

	extern inline function new(v: Int)
		this = v;
}
