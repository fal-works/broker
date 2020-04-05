package broker.input.interfaces;

/**
	A virtual gamepad object consisting of `buttons` and `stick`.
**/
interface Gamepad<B, M:GenericButtonStatusMap<B>> {
	/**
		Mapping from virtual buttons to their corresponding status.
	**/
	final buttons: M;

	/**
		A virtual analog stick.
	**/
	final stick: Stick;

	/**
		Updates the status of `this` gamepad.
	**/
	function update(): Void;
}
