package integration.global;

import broker.input.Stick;
import broker.input.builtin.simple.ButtonStatusMap;
import broker.input.builtin.simple.ShmupGamepad;
import broker.input.heaps.HeapsInputTools;
import integration.Settings;

class Gamepad {
	public static final buttons = ButtonStatusMap.create(HeapsInputTools.createButtonChecker(
		Settings.keyCodeMap,
		Settings.buttonCodeMap,
		0
	));
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
