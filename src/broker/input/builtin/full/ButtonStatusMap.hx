package broker.input.builtin.full;

import banker.vector.Vector;
import broker.input.ButtonStatus;
import broker.input.interfaces.ButtonStatusMapWithDpad;

/**
	Mapping from values of `broker.input.builtin.full.Button`
	to their corresponding status.
**/
@:build(banker.finite.FiniteKeys.from(Button))
@:banker_verified
@:banker_final
class ButtonStatusMap implements ButtonStatusMapWithDpad<Button> {
	/**
		Factory function for initializing each value.
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
}
