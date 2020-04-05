package broker.input.builtin.simple;

class Dummy {
	/**
		Null object for `ButtonStatusMap`.
	**/
	public static final dummyButtonStatusMap = ButtonStatusMap.create(_ -> () -> false);

	/**
		Null object for `Gamepad`.
	**/
	public static final dummyGamepad = new Gamepad(dummyButtonStatusMap, new Stick());
}
