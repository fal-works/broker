package integration.gamepad;

import broker.input.Stick;
import broker.input.heaps.HeapsInputTools;
import broker.input.heaps.HeapsPadPort;
import broker.input.builtin.simple.Button;
import broker.input.builtin.simple.ButtonStatusMap;

@:structInit
class GamepadBuilder {
	public final keyCodeMap: Map<Button, Array<Int>>;
	public final padButtonCodeMap: Map<Button, Array<Int>>;

	public final heapsPadPort: HeapsPadPort;
	public final analogStickThreshold: Float;

	public final speedChangeButton: Button;
	public final defaultSpeed: Float;
	public final alternativeSpeed: Float;

	public function new(
		keyCodeMap: Map<Button, Array<Int>>,
		padButtonCodeMap: Map<Button, Array<Int>>,
		heapsPadPort: HeapsPadPort,
		analogStickThreshold: Float,
		speedChangeButton: Button,
		defaultSpeed: Float,
		alternativeSpeed: Float
	) {
		this.keyCodeMap = keyCodeMap;
		this.padButtonCodeMap = padButtonCodeMap;

		this.heapsPadPort = heapsPadPort;
		this.analogStickThreshold = analogStickThreshold;

		this.speedChangeButton = speedChangeButton;
		this.defaultSpeed = defaultSpeed;
		this.alternativeSpeed = alternativeSpeed;
	}

	public function build() {
		final getButtonChecker = HeapsInputTools.createButtonCheckerGenerator(
			keyCodeMap,
			padButtonCodeMap,
			heapsPadPort
		);
		final buttons = ButtonStatusMap.create(getButtonChecker);

		final stick = new Stick();

		return new Gamepad(
			buttons,
			stick,
			{
				heapsPadPort: heapsPadPort,
				analogStickThreshold: analogStickThreshold,
				speedChangeButtonStatus: buttons.get(speedChangeButton),
				defaultSpeed: defaultSpeed,
				alternativeSpeed: alternativeSpeed
			}
		);
	}
}
