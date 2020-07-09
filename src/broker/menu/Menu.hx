package broker.menu;

import broker.menu.internal.MenuData;

/**
	A menu UI object.
	Use `Menu.create()` for instantiating.
**/
@:notNull @:forward(x, y, setPosition, visible, addOption, addObject, removeObject)
abstract Menu(MenuData) to Object {
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
		@return The `MenuOption` that is currently focused.
	**/
	public inline function getFocused(): Maybe<MenuOption> {
		return if (this.index.isNone()) Maybe.none() else {
			Maybe.from(this.options[this.index.unwrap()]);
		};
	}

	/**
		@return `true` if `option` is currently focused by `this` menu.
	**/
	public inline function focuses(option: MenuOption): Bool {
		final focused = getFocused();
		return if (focused.isNone()) false else focused.unwrap() == option;
	}

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
		defocus();
		this.index = index;
		this.options[index].focus();
	}

	/**
		Defocuses the currently focused option.
		No effect if none is focused.
	**/
	public function defocus(): Void {
		final focused = getFocused();
		if (focused.isSome()) defocusOption(focused.unwrap());
	}

	/**
		Selects the currently focused option.
		No effect if none is focused.
	**/
	public function select(): Void {
		final focused = getFocused();
		if (focused.isSome()) selectOption(focused.unwrap());
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

		final maybeFocused = getFocused();
		if (maybeFocused.isNone()) return;
		final focused = maybeFocused.unwrap();

		if (listenDefocus(focused)) {
			defocusOption(focused);
			return;
		}

		if (listenSelect(focused)) {
			selectOption(focused);
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
		@return `true` if the `focused` option is to be defocused.
	**/
	inline function listenDefocus(focused: MenuOption): Bool
		return this.listenDefocus.logicalOr() || focused.listenDefocus();

	/**
		Called in `listen()`.
		@return `true` if the `focused` option is to be selected.
	**/
	inline function listenSelect(focused: MenuOption): Bool
		return this.listenSelect.logicalOr() || focused.listenSelect();

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

	/**
		Defocuses the `focused` option.
	**/
	function defocusOption(focused: MenuOption): Void {
		focused.defocus();
		this.index = MaybeUInt.none;
	}

	/**
		Selects the `focused` option.
	**/
	function selectOption(focused: MenuOption): Void {
		focused.select();
		if (this.deactivateOnSelect) deactivate();
	}
}
