package broker.input.interfaces;

import banker.finite.interfaces.FiniteKeysMap;

/**
	Mapping from virtual buttons (of any enum abstract type) to their corresponding status.
**/
interface GenericButtonStatusMap<T> extends FiniteKeysMap<T, ButtonStatus> {}
