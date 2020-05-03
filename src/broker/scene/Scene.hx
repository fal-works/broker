package broker.scene;

/**
	Base class for implementing `broker.scene.interfaces.Scene`.
**/
class Scene implements broker.scene.interfaces.Scene {
	/**
		Updates `this` scene.
	**/
	public function update(): Void {}

	/**
		Called when `this` scene becomes the top in the scene stack.
	**/
	public function activate(): Void {}

	/**
		Called when `this` scene is no more the top in the scene stack but is not immediately destroyed.
	**/
	public function deactivate(): Void {}

	/**
		Destroyes `this` scene.
	**/
	public function destroy(): Void {}
}
