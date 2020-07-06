package broker.scene;

/**
	Drawing layer.
**/
@:notNull @:forward(setFilter)
abstract Layer(SceneObject) from SceneObject to SceneObject {
	/**
		`this` as the underlying type.
	**/
	public var data(get, never): SceneObject;

	public extern inline function new() {
		this = new SceneObject();
	}

	public extern inline function add(object: SceneObject): Void
		this.addChild(object);

	public extern inline function remove(object: SceneObject): Void
		this.removeChild(object);

	public extern inline function clear(): Void
		this.removeChildren();

	extern inline function get_data()
		return this;
}
