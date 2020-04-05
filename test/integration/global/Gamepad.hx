package integration.global;

import broker.input.Stick;
import broker.input.builtin.simple.ButtonStatusMap;
import broker.input.builtin.simple.ShmupGamepad;
import broker.input.heaps.HeapsInputTools;
import broker.input.heaps.HeapsPadMultitap;
import integration.Settings;

class Gamepad {
	public static final buttons = {
		final getButtonChecker = HeapsInputTools.createButtonCheckerGenerator(
			Settings.keyCodeMap,
			Settings.buttonCodeMap,
			HeapsPadMultitap.ports[0]
		);
		ButtonStatusMap.create(getButtonChecker);
	}

	public static final stick = new Stick();

	public static var gamepad(default, null) = new ShmupGamepad(
		buttons,
		stick,
		X,
		Settings.highSpeed,
		Settings.lowSpeed
	);

	public static inline function update(): Void
		gamepad.update();
}
