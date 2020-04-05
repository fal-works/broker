package broker.input.builtin.simple;

import banker.vector.Vector;
import broker.input.ButtonStatus;
import broker.input.interfaces.GenericButtonStatusMap;

/**
	Mapping from values of `broker.input.builtin.simple.Button`
	to their corresponding status.
**/
@:build(banker.finite.FiniteKeys.from(Button))
@:banker_verified
@:banker_final
class ButtonStatusMap implements GenericButtonStatusMap<Button> {
	/**
		@param getButtonChecker Function that returns a button checker, which is
		another function that returns `true` if `button` should be considered pressed.
		@return New `ButtonStatusMap` instance.
	**/
	public static function create(
		getButtonChecker: (button: Button) -> (() -> Bool)
	): ButtonStatusMap {
		getButtonCheckerFunction = getButtonChecker;
		final statusMap = new ButtonStatusMap();
		getButtonCheckerFunction = getButtonCheckerDummy;

		return statusMap;
	}

	/**
		Internal null object for `getButtonCheckerFunction`.
	**/
	static final getButtonCheckerDummy = function(button: Button): () -> Bool {
		throw "getButtonCheckerFunction() is not set. This code should not be reached.";
	}

	/**
		Internally used in `initialValue()`.
		Is set and reset every time `create()` is called.
	**/
	static var getButtonCheckerFunction = getButtonCheckerDummy;

	/**
		Function for initializing each variable.
		@see `FiniteKeys` of `banker` library.
	**/
	static function initialValue(button: Button): ButtonStatus {
		final buttonIsDown = getButtonCheckerFunction(button);

		return new ButtonStatus(buttonIsDown);
	}

	private function new() {}
}
