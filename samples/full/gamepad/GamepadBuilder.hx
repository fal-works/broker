package full.gamepad;

import broker.input.Stick;
import broker.input.heaps.HeapsInputTools;
import broker.input.heaps.HeapsPadPort;
import broker.input.builtin.simple.Button;
import broker.input.builtin.simple.ButtonStatusMap;

@:structInit
class GamepadBuilder implements ripper.Data {
	public final keyCodeMap: Map<Button, Array<Int>>;
	public final padButtonCodeMap: Map<Button, Array<Int>>;

	public final heapsPadPort: HeapsPadPort;
	public final analogStickThreshold: Float;

	public final speedChangeButton: Button;
	public final defaultSpeed: Float;
	public final alternativeSpeed: Float;

	public function build() {
		final buttons = new ButtonStatusMap();

		final getButtonChecker = HeapsInputTools.createButtonCheckerGenerator(
			keyCodeMap,
			padButtonCodeMap,
			heapsPadPort
		);
		final updateButtonStatus = buttons.createUpdater(getButtonChecker);

		final parameters: GamepadParameters = {
			updateButtonStatus: updateButtonStatus,
			heapsPadPort: heapsPadPort,
			analogStickThreshold: analogStickThreshold,
			speedChangeButtonStatus: buttons.get(speedChangeButton),
			defaultSpeed: defaultSpeed,
			alternativeSpeed: alternativeSpeed
		};

		return new Gamepad(buttons, parameters);
	}
}
