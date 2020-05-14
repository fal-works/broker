package broker.scene.heaps;

#if heaps
class Layer implements broker.scene.Layer {
	public final heapsObject: h2d.Object;

	public function new(?parent: h2d.Object) {
		this.heapsObject = new h2d.Object(parent);
	}
}
#end
