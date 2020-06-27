package broker.scene.heaps;

#if heaps
abstract Layer(h2d.Object) from h2d.Object to h2d.Object {
	/**
		`this` as the underlying type.
	**/
	public var data(get, never): h2d.Object;

	public function new() {
		this = new h2d.Object();
	}

	public function add(object: SceneObject): Void
		this.addChild(object);

	public function remove(object: SceneObject): Void
		this.removeChild(object);

	public function clear(): Void
		this.removeChildren();

	extern inline function get_data()
		return this;
}
#end
