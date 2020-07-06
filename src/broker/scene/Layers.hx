package broker.scene;

/**
	Set of layers contained in a `Scene`.
**/
class Layers {
	/**
		Background layer.
	**/
	public final background: Layer;

	/**
		Main layer.
	**/
	public final main: Layer;

	/**
		Surface layer.
	**/
	public final surface: Layer;

	public function new() {
		this.background = new Layer();
		this.main = new Layer();
		this.surface = new Layer();
	}

	/**
		Adds `this` layers to `object`.
	**/
	public function addTo(object: SceneObject): Void {
		object.addChild(this.background);
		object.addChild(this.main);
		object.addChild(this.surface);
	}
}
