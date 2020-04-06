package broker.input.interfaces;

import banker.finite.interfaces.FiniteKeysMap;

/**
	Mapping from virtual buttons (of any enum abstract type) to their corresponding status.
**/
@:using(broker.input.interfaces.GenericButtonStatusMap.ButtonStatusMapExtension)
interface GenericButtonStatusMap<T> extends FiniteKeysMap<T, ButtonStatus> {}

class ButtonStatusMapExtension {
	/**
		Creates a function for updating `this` every frame.
		@param getButtonChecker Function that returns another function
		for checking if a given `button` is down.
		@return Function that updates all button status of `this`.
	**/
	#if !broker_generic_disable
	@:generic
	#end
	public static function createUpdater<T>(
		_this: broker.input.interfaces.GenericButtonStatusMap<T>,
		getButtonChecker: (button: T) -> (() -> Bool)
	) {
		final tickers = _this.exportKeys().ref.map(button -> {
			final buttonIsDown = getButtonChecker(button);
			final status = _this.get(button);
			return () -> status.update(buttonIsDown());
		});
		return () -> for (i in 0...tickers.length) tickers[i]();
	}
}
