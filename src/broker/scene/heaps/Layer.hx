package broker.scene.heaps;

#if heaps
abstract Layer(h2d.Object) from h2d.Object to h2d.Object to SceneObject {
	/**
		`this` as the underlying type.
	**/
	public var data(get, never): h2d.Object;

	public extern inline function new() {
		this = new h2d.Object();
	}

	public extern inline function add(object: SceneObject): Void
		this.addChild(object);

	public extern inline function remove(object: SceneObject): Void
		this.removeChild(object);

	public extern inline function clear(): Void
		this.removeChildren();

	public extern inline function setFilter(filter: Filter): Void
		this.filter = filter;

	extern inline function get_data()
		return this;
}
#end
