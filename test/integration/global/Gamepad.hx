package integration.global;

import broker.input.Stick;
import broker.input.builtin.simple.ButtonStatusMap;
import broker.input.builtin.simple.ShmupGamepad;
import integration.Settings;

class Gamepad {
	public static final buttons = ButtonStatusMap.createFromHeapsKeyCodeMap(Settings.keyCodeMap);
	public static final stick = new Stick();
	static final gamepadUnit = new ShmupGamepad(
		buttons,
		stick,
		X,
		Settings.highSpeed,
		Settings.lowSpeed
	);

	public static inline function update(): Void
		gamepadUnit.update();
}
