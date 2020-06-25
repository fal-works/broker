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

	public function new(layerFactory: () -> Layer) {
		this.background = layerFactory();
		this.main = layerFactory();
		this.surface = layerFactory();
	}
}
