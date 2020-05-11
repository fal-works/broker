package broker.scene;

/**
	Game scene object.
**/
interface Scene<T: Layer> {
	/**
		Background layer.
	**/
	final background: T;

	/**
		Main layer.
	**/
	final mainLayer: T;

	/**
		Surface layer.
	**/
	final surface: T;

	/**
		Updates `this` scene.
	**/
	function update(): Void;

	/**
		Called when `this` scene becomes the top in the scene stack.
	**/
	function activate(): Void;

	/**
		Called when `this` scene is no more the top in the scene stack but is not immediately destroyed.
	**/
	function deactivate(): Void;

	/**
		Destroys `this` scene.
	**/
	function destroy(): Void;
}
