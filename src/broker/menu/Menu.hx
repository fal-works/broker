package broker.menu;

import broker.scene.SceneObject;
import broker.menu.internal.MenuData;

/**
	A menu UI object.
	Use `Menu.create()` for instantiating.
**/
@:notNull @:forward(x, y, setPosition, addOption, addObject, removeObject)
abstract Menu(MenuData) to SceneObject {
	/**
		Creates a `Menu` instance.
		@see `broker.menu.MenuParameters`
	**/
	public static function create(parameters: MenuParameters): Menu {
		return new MenuData(parameters);
	}

	@:from static function fromData(data: MenuData): Menu {
		return new Menu(data);
	}

	/**
		Activates `this` menu.
	**/
	public function activate(): Void {
		this.isActive = true;
		final onActivate = this.onActivate;
		for (i in 0...onActivate.length) onActivate[i](this);
	}

	/**
		Deactivates `this` menu so that it does not listen user input.
	**/
	public function deactivate(): Void {
		this.isActive = false;
		final onDeactivate = this.onDeactivate;
		for (i in 0...onDeactivate.length) onDeactivate[i](this);
	}

	/**
		Adds `options` to `this` menu.
	**/
	public function addOptions(options: Array<MenuOption>): Void
		for (i in 0...options.length) this.addOption(options[i]);

	/**
		Runs `callback` for each `MenuOption`.
	**/
	public function forEachOption(callback: (option: MenuOption) -> Void): Void
		for (i in 0...this.options.length) callback(this.options[i]);

	/**
		Focuses on `option` in `this` menu.
		Also defocuses the currently focused option.

		Throws error if `this` does not contain `option`.
	**/
	public inline function focus(option: MenuOption): Void
		focusAt(indexOf(option));

	/**
		Focuses on the option at `index` in `this` menu.
		Also defocuses the currently focused option.
	**/
	public function focusAt(index: UInt): Void {
		final options = this.options;
		if (options.length <= index) return;

		defocus();
		this.index = index;

		options[index].focus();
	}

	/**
		Defocuses the currently focused option.
	**/
	public function defocus(): Void {
		final currentIndex = this.index;
		if (currentIndex.isSome())
			this.options[currentIndex.unwrap()].defocus();

		this.index = MaybeUInt.none;
	}

	/**
		Selects the currently focused option.
		No effect if none is focused.
	**/
	public function select(): Void {
		final index = this.index;
		if (index.isSome()) {
			this.options[index.unwrap()].select();
			if (this.deactivateOnSelect) deactivate();
		}
	}

	/**
		Gets index of `option` in `this` menu.

		Throws error if `this` does not contain `option`.
	**/
	public function indexOf(option: MenuOption): UInt {
		final options = this.options;
		final maxIndex = options.length;
		var found = MaybeUInt.none;
		var i = UInt.zero;
		while (i < maxIndex) {
			if (options[i] == option) {
				found = i;
				break;
			}
			++i;
		}

		if (found.isNone()) throw "Passed menu option that is not a member of this menu.";
		return found.unwrap();
	}

	/**
		if `this.isActive`, listens to user input and updates `this` menu.
	**/
	public function listen(): Void {
		if (!this.isActive) return;

		final newFocusedIndex = listenfocus();
		if (newFocusedIndex.isSome()) {
			focusAt(newFocusedIndex.unwrap());
			return;
		}

		if (listenSelect()) {
			select();
			return;
		}
	}

	/**
		Called in `listen()`.
		@return Index of the option to be newly focused.
	**/
	function listenfocus(): MaybeUInt {
		final options = this.options;
		final optionCount = options.length;

		if (this.listenFocusPrevious.logicalOr()) {
			final currentIndex = this.index;
			if (currentIndex.isNone()) return UInt.zero;
			else return (currentIndex.unwrap().minusOne().int() + optionCount) % optionCount;
		}

		if (this.listenFocusNext.logicalOr()) {
			final currentIndex = this.index;
			if (currentIndex.isNone()) return UInt.zero;
			else return currentIndex.unwrap().plusOne() % optionCount;
		}

		for (i in 0...optionCount) {
			if (options[i].listenFocus())
				return i;
		}

		return MaybeUInt.none;
	}

	/**
		Called in `listen()`.
		@return `true` if the currently focused option is to be selected.
	**/
	function listenSelect(): Bool {
		return if (this.index.isNone()) false else {
			this.listenSelect.logicalOr() || this.options[this.index.unwrap()].listenSelect();
		};
	}

	inline function new(data: MenuData) {
		this = data;

		if (this.automaticFocus) {
			final options = this.options;
			for (i in 0...this.options.length) {
				final option = options[i];
				if (i == this.index) option.focus();
				else option.defocus();
			}
		}
	}
}
