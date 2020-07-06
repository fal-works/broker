package broker.menu;

import broker.menu.internal.Types;

/**
	Option element in a `Menu`.
**/
@:structInit
class MenuOption {
	public final object: Object;

	final onSelect: VoidFuncs;
	final onFocus: VoidFuncs;
	final onDefocus: VoidFuncs;
	final listenFocusCallbacks: BoolFuncs;
	final listenDefocusCallbacks: BoolFuncs;
	final listenSelectCallbacks: BoolFuncs;

	/**
		Creates a `MenuOption` instance.
		@param object Object to be added to the scene tree.
		@param onSelect Callback to be run when `this` option is selected.
		@param onFocus Callback to be run when `this` option is focused.
		@param onDefocus Callback to be run when `this` option is defocused.
		@param listenFocus Function that returns `true` if `this` option is to be focused.
		@param listenDefocus Function that returns `true` if `this` option is to be defocused.
		@param listenSelect Function that returns `true` if `this` option is to be selected.
	**/
	public function new(
		object: Object,
		?onSelect: VoidFuncs,
		?onFocus: VoidFuncs,
		?onDefocus: VoidFuncs,
		?listenFocus: BoolFuncs,
		?listenDefocus: BoolFuncs,
		?listenSelect: BoolFuncs
	) {
		this.object = object;
		this.onSelect = Nulls.coalesce(onSelect, []);
		this.onFocus = Nulls.coalesce(onFocus, []);
		this.onDefocus = Nulls.coalesce(onDefocus, []);
		this.listenFocusCallbacks = Nulls.coalesce(listenFocus, []);
		this.listenDefocusCallbacks = Nulls.coalesce(listenDefocus, []);
		this.listenSelectCallbacks = Nulls.coalesce(listenSelect, []);
	}

	public inline function listenFocus(): Bool
		return this.listenFocusCallbacks.logicalOr();

	public inline function listenDefocus(): Bool
		return this.listenDefocusCallbacks.logicalOr();

	public inline function listenSelect(): Bool
		return this.listenSelectCallbacks.logicalOr();

	public inline function focus(): Void
		this.onFocus.runAll();

	public inline function defocus(): Void
		this.onDefocus.runAll();

	public inline function select(): Void
		this.onSelect.runAll();
}
