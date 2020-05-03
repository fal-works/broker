package broker.scene.interfaces;

/**
	Game scene object.
**/
interface Scene {
	function update(): Void;
	function activate(): Void;
	function deactivate(): Void;
	function destroy(): Void;
}
