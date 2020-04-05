package broker.input.builtin.simple;

import broker.input.GamepadBase;

class Dummy {
	/**
		Null object for `ButtonStatusMap`.
	**/
	public static final dummyButtonStatusMap = ButtonStatusMap.create(_ -> () -> false);

	/**
		Null object for `Gamepad`.
	**/
	public static final dummyGamepad = new GamepadBase<Button, ButtonStatusMap, Stick>(
		dummyButtonStatusMap,
		new Stick()
	);
}
