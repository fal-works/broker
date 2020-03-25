package broker.input;

import banker.finite.interfaces.FiniteKeysMap;

/**
	A virtual gamepad object consisting of `buttons` and `stick`.
**/
#if !broker_generic_disable
@:generic
#end
class Gamepad<B, M: FiniteKeysMap<B, ButtonStatus>, S: Stick> {
	public final buttons: M;
	public final stick: S;

	/**
		@param buttons Mapping between buttons and their status.
		@param stick Any `Stick` object.
	**/
	public function new(
		buttons: M,
		stick: S
	) {
		this.buttons = buttons;
		this.stick = stick;
	}

	/**
		Updates status of all `buttons`.
		Override this method for updating `stick` as well.
	**/
	public function update(): Void
		this.buttons.forEachValue(status -> status.update());
}
