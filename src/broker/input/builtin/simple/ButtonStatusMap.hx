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
		Function for initializing each variable.
		@see `FiniteKeys` of `banker` library.
	**/
	static function initialValue(_: Button): ButtonStatus
		return new ButtonStatus();

	/**
		Reflects the status of `this` direction buttons to `stick`.
		The stick displacement is normalized with `this.sensitivity`.
		@return `true` if any direction button is pressed.
	**/
	public inline function reflectToStick(stick: Stick): Bool
		return stick.reflect(this.D_LEFT, this.D_UP, this.D_RIGHT, this.D_DOWN);

	/**
		Creates a function for updating `this` once in a frame.
		@param getButtonChecker Function that returns another function
		for checking if a given `button` is down.
		@return Function that updates all button status of `this`.
	**/
	public function createUpdater(getButtonChecker: (button: Button) -> (() -> Bool)) {
		final tickers = this.exportKeys().ref.map(button -> {
			final buttonIsDown = getButtonChecker(button);
			final status = this.get(button);
			return () -> status.update(buttonIsDown());
		});
		return () -> for (i in 0...tickers.length) tickers[i]();
	}
}
