package broker.input.interfaces;

/**
	A virtual gamepad object consisting of `buttons`, two `Stick` instances and trigger button values.
**/
interface FullGamepad<B, M:ButtonStatusMapWithDpad<B>, S:Stick>
	extends BasicGamepad<B, M, S> {
	/**
		A virtual right analog stick.
	**/
	final rightStick: S;

	/**
		Value of left trigger button.
	**/
	var leftTrigger: Float;

	/**
		Value of right trigger button.
	**/
	var rightTrigger: Float;
}
