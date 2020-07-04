package broker.menu;

import broker.scene.SceneObject;
import broker.menu.internal.Types;

/**
	Parameters for creating `Menu` instances.
**/
@:structInit
class MenuParameters {
	public final listenSelect: BoolFuncs;
	public final initialOptions: Array<MenuOption>;
	public final listenFocusPrevious: BoolFuncs;
	public final listenFocusNext: BoolFuncs;
	public final onAddOption: Array<(object: SceneObject, index: UInt) -> Void>;
	public final onActivate: Array<(menu: Menu) -> Void>;
	public final onDeactivate: Array<(menu: Menu) -> Void>;
	public final initialIndex: MaybeUInt;
	public final isActive: Bool;
	public final automaticFocus: Bool;

	/**
		@param listenSelect Functions that return `true` if the currently focused option should be selected.
		@param options Initial `MenuOption` instances.
		@param listenFocusPrevious Functions that return `true` if the previous option should be focused.
		@param listenFocusNext Functions that return `true` if the next option should be focused.
		@param onAddOption Callback to be run when any `MenuOption` is added to `this` menu.
		@param onActivate Callback to be run when `this` menu is activated.
		@param onDeactivate Callback to be run when `this` menu is deactivated.
		@param initialIndex The index of `MenuOption` initially focused (`onFocus()`/`onDefocus()` are not called when intantiating).
		@param isActive Initial activation state (`onActivate()`/`onDeactivate()` are not called when intantiating).
		@param automaticFocus If `true`, automatically focuses/defocuses options when instantiating `Menu` or calling `addOption()`.
	**/
	public function new(
		listenSelect: BoolFuncs,
		?initialOptions: Array<MenuOption>,
		?listenFocusPrevious: BoolFuncs,
		?listenFocusNext: BoolFuncs,
		?onAddOption: Array<(object: SceneObject, index: UInt) -> Void>,
		?onActivate: Array<(menu: Menu) -> Void>,
		?onDeactivate: Array<(menu: Menu) -> Void>,
		initialIndex = MaybeUInt.none,
		isActive = true,
		automaticFocus = true
	) {
		this.listenSelect = listenSelect;

		this.initialOptions = initialOptions.orNew();
		this.listenFocusPrevious = listenFocusPrevious.orNew();
		this.listenFocusNext = listenFocusNext.orNew();
		this.onAddOption = onAddOption.orNew();
		this.onActivate = onActivate.orNew();
		this.onDeactivate = onDeactivate.orNew();
		this.initialIndex = initialIndex;
		this.isActive = isActive;
		this.automaticFocus = automaticFocus;
	}
}
