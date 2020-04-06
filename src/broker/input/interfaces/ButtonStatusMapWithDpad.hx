package broker.input.interfaces;

/**
	Mapping from virtual buttons (of any enum abstract type including values for D-Pad buttons)
	to their corresponding status.
**/
interface ButtonStatusMapWithDpad<T> extends GenericButtonStatusMap<T> {
	/**
		Reflects the status of `this` direction buttons to `stick`.
		@return `true` if any direction button is pressed.
	**/
	function reflectToStick(stick: Stick): Bool;
}
