package broker.menu;

import broker.scene.SceneObject;
import broker.menu.internal.Types;

/**
	Option element in a `Menu`.
**/
@:structInit
class MenuOption {
	public final object: SceneObject;
	public final onSelect: VoidFuncs;
	public final onFocus: VoidFuncs;
	public final onDefocus: VoidFuncs;
	public final listenFocus: BoolFuncs;

	/**
		Creates a `MenuOption` instance.
		@param object Object to be added to the scene tree.
		@param onSelect Callback to be run when `this` option is selected.
		@param onFocus Callback to be run when `this` option is focused.
		@param onDefocus Callback to be run when `this` option is defocused.
		@param listenFocus Function that returns `true` if `this` option should be focused.
	**/
	public function new(
		object: SceneObject,
		?onSelect: VoidFuncs,
		?onFocus: VoidFuncs,
		?onDefocus: VoidFuncs,
		?listenFocus: BoolFuncs
	) {
		this.object = object;
		this.onSelect = Nulls.coalesce(onSelect, []);
		this.onFocus = Nulls.coalesce(onFocus, []);
		this.onDefocus = Nulls.coalesce(onDefocus, []);
		this.listenFocus = Nulls.coalesce(listenFocus, []);
	}

	public inline function select(): Void
		this.onSelect.runAll();

	public inline function focus(): Void
		this.onFocus.runAll();

	public inline function defocus(): Void
		this.onDefocus.runAll();
}
