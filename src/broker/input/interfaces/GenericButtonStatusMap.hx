package broker.input.interfaces;

import banker.finite.interfaces.FiniteKeysMap;

/**
	Mapping from virtual buttons (of any enum abstract type) to their corresponding status.
**/
interface GenericButtonStatusMap<T> extends FiniteKeysMap<T, ButtonStatus> {
	/**
		Creates a function for updating `this` every frame.
		@param getButtonChecker Function that returns another function
		for checking if a given `button` is down.
		@return Function that updates all button status of `this`.
	**/
	function createUpdater(getButtonChecker: (button: T) -> (() -> Bool)): () -> Void;
}
