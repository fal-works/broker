package broker.scene.heaps;

import h2d.Object;

class Layer implements broker.scene.interfaces.Layer {
	final heapsLayer: Object;

	public function new(?parent: Object) {
		this.heapsLayer = new Object();
	}
}
