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
	public final listenDefocus: BoolFuncs;
	public final onAddOption: Array<(object: SceneObject, index: UInt) -> Void>;
	public final onActivate: Array<(menu: Menu) -> Void>;
	public final onDeactivate: Array<(menu: Menu) -> Void>;
	public final initialIndex: MaybeUInt;
	public final isActive: Bool;
	public final automaticFocus: Bool;
	public final deactivateOnSelect: Bool;

	/**
		@param listenSelect Functions that return `true` if the currently focused option is to be selected.
		@param options Initial `MenuOption` instances.
		@param listenFocusPrevious Functions that return `true` if the previous option is to be focused.
		@param listenFocusNext Functions that return `true` if the next option is to be focused.
		@param listenDefocus Functions that return `true` if the currently focused option is to be defocused.
		@param onAddOption Callback to be run when any `MenuOption` is added to the menu.
		@param onActivate Callback to be run when the menu is activated.
		@param onDeactivate Callback to be run when the menu is deactivated.
		@param initialIndex The index of `MenuOption` initially focused (`onFocus()`/`onDefocus()` are not called when intantiating).
		@param isActive Initial activation state (`onActivate()`/`onDeactivate()` are not called when intantiating).
		@param automaticFocus If `true`, automatically focuses/defocuses options when instantiating `Menu` or calling `addOption()`.
		@param deactivateOnSelect If `true`, automatically deactivates the menu when any option is selected.
	**/
	public function new(
		listenSelect: BoolFuncs,
		?initialOptions: Array<MenuOption>,
		?listenFocusPrevious: BoolFuncs,
		?listenFocusNext: BoolFuncs,
		?listenDefocus: BoolFuncs,
		?onAddOption: Array<(object: SceneObject, index: UInt) -> Void>,
		?onActivate: Array<(menu: Menu) -> Void>,
		?onDeactivate: Array<(menu: Menu) -> Void>,
		initialIndex = MaybeUInt.none,
		isActive = true,
		automaticFocus = true,
		deactivateOnSelect = true
	) {
		this.listenSelect = listenSelect;

		this.initialOptions = initialOptions.orNew();
		this.listenFocusPrevious = listenFocusPrevious.orNew();
		this.listenFocusNext = listenFocusNext.orNew();
		this.listenDefocus = listenDefocus.orNew();
		this.onAddOption = onAddOption.orNew();
		this.onActivate = onActivate.orNew();
		this.onDeactivate = onDeactivate.orNew();
		this.initialIndex = initialIndex;
		this.isActive = isActive;
		this.automaticFocus = automaticFocus;
		this.deactivateOnSelect = deactivateOnSelect;
	}
}
