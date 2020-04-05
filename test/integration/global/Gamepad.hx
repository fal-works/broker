package integration.global;

import broker.input.Stick;
import broker.input.builtin.simple.ButtonStatusMap;
import broker.input.builtin.simple.ShmupGamepad;
import broker.input.heaps.HeapsPadTools;
import integration.Settings;

class Gamepad {
	public static final buttons = ButtonStatusMap.createFromHeapsCodeMap(
		Settings.keyCodeMap,
		HeapsPadTools.sockets[0],
		Settings.buttonCodeMap
	);
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
