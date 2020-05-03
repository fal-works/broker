package broker.scene;

/**
	Base class for implementing `broker.scene.interfaces.Scene`.
**/
class Scene implements broker.scene.interfaces.Scene {
	public function update(): Void {}
	public function activate(): Void {}
	public function deactivate(): Void {}
	public function destroy(): Void {}
}
