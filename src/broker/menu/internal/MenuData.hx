package broker.menu.internal;

import broker.scene.SceneObject;
import broker.scene.internal.SceneObjectData;
import broker.menu.internal.Types;

@:structInit
@:allow(broker.menu.Menu)
class MenuData extends SceneObjectData {
	final options: Array<MenuOption>;
	final listenFocusPrevious: BoolFuncs;
	final listenFocusNext: BoolFuncs;
	final listenSelect: BoolFuncs;
	final onAddOption: Array<(object: SceneObject, index: UInt) -> Void>;
	final onActivate: Array<(menu: Menu) -> Void>;
	final onDeactivate: Array<(menu: Menu) -> Void>;
	final automaticFocus: Bool;
	final deactivateOnSelect: Bool;

	/**
		Index of `MenuOption` currently focused.
	**/
	var index: MaybeUInt;

	/**
		`true` to listen user input.
	**/
	var isActive: Bool;

	public function new(parameters: MenuParameters) {
		super();

		final prm = parameters;

		this.options = [];
		this.listenSelect = prm.listenSelect.copy();
		this.listenFocusPrevious = prm.listenFocusPrevious.copy();
		this.listenFocusNext = prm.listenFocusNext.copy();
		this.onAddOption = prm.onAddOption.copy();
		this.onActivate = prm.onActivate.copy();
		this.onDeactivate = prm.onDeactivate.copy();
		this.automaticFocus = prm.automaticFocus;
		this.deactivateOnSelect = prm.deactivateOnSelect;

		final initialOptions = prm.initialOptions.copy();
		final initialIndex = if (prm.initialIndex.int() < initialOptions.length)
			prm.initialIndex else MaybeUInt.none;

		this.index = initialIndex;
		this.isActive = prm.isActive;

		for (i in 0...initialOptions.length) addOption(initialOptions[i]);
	}

	/**
		Adds `option` to `this` menu.
	**/
	public function addOption(option: MenuOption): Void {
		final onAdd = this.onAddOption;
		for (i in 0...onAdd.length) onAdd[i](option.object, this.options.length);

		this.options.push(option);
		this.addObject(option.object);

		if (this.automaticFocus) option.defocus();
	}

	/**
		Adds an object that is not a part of any `MenuOption`.
	**/
	public inline function addObject(object: SceneObject): Void {
		#if heaps
		this.addChild(object);
		#end
	}

	/**
		Removes `object` that has been added by `addObject()`.
	**/
	public inline function removeObject(object: SceneObject): Void {
		#if heaps
		this.removeChild(object);
		#end
	}
}
