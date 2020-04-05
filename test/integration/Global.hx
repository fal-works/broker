package integration;

import broker.input.Stick;
import broker.input.builtin.simple.Button;
import broker.input.builtin.simple.ButtonStatusMap;
import broker.input.GamepadBase;
import broker.input.heaps.HeapsInputTools;
import broker.input.heaps.HeapsPadMultitap;
import broker.input.heaps.HeapsPadPort;
import integration.Settings;

class Global {
	public static var gamepad(default, null) = createGamepad(
		Settings.keyCodeMap,
		Settings.buttonCodeMap,
		HeapsPadMultitap.ports[0],
		X,
		0.1
	);

	static function createGamepad(
		keyCodeMap: Map<Button, Array<Int>>,
		padButtonCodeMap: Map<Button, Array<Int>>,
		padPort: HeapsPadPort,
		speedChangeButton: Button,
		analogStickThreshold: Float
	) {
		final getButtonChecker = HeapsInputTools.createButtonCheckerGenerator(
			keyCodeMap,
			padButtonCodeMap,
			padPort
		);
		final buttons = ButtonStatusMap.create(getButtonChecker);

		final stick = new Stick();

		final speedChangeButton = buttons.get(speedChangeButton);

		return new GamepadBase<Button, ButtonStatusMap>(
			buttons,
			stick,
			gamepad -> {
				final speed = if (speedChangeButton.isPressed)
					Settings.lowSpeed
				else
					Settings.highSpeed;

				padPort.updateStickFromLeftAnalog(stick);
				if (stick.distance > analogStickThreshold) {
					stick.setDistance(speed);
				} else {
					buttons.reflectToStick(stick);
					stick.multiplyDistance(speed);
				}
			}
		);
	}
}
