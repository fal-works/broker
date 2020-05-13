package broker.scene;

import broker.timer.Timers;
import broker.color.ArgbColor;

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
		Timers attached to `this` scene.
	**/
	final timers: Timers;

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

	/**
		Starts fade-in effect.
		@param color The starting color.
		@param duration The duration frame count.
	**/
	function fadeInFrom(color: ArgbColor, duration: Int): Void;
}
