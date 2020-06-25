package broker.scene.heaps;

#if heaps
abstract Layer(h2d.Object) from h2d.Object to h2d.Object {
	public function add(object: SceneObject): Void
		this.addChild(object);

	public function remove(object: SceneObject): Void
		this.removeChild(object);

	public function clear(): Void
		this.removeChildren();
}
#end
