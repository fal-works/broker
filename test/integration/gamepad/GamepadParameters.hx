package integration.gamepad;

import broker.input.ButtonStatus;
import broker.input.heaps.HeapsPadPort;

/**
	Set of parameters to be stored/used by a `Gamepad` instance.
**/
@:structInit
class GamepadParameters {
	public final updateButtonStatus: () -> Void;
	public final heapsPadPort: HeapsPadPort;
	public final analogStickThreshold: Float;

	public final speedChangeButtonStatus: ButtonStatus;
	public final defaultSpeed: Float;
	public final alternativeSpeed: Float;

	public function new(
		heapsPadPort: HeapsPadPort,
		updateButtonStatus: () -> Void,
		analogStickThreshold: Float,
		speedChangeButtonStatus: ButtonStatus,
		defaultSpeed: Float,
		alternativeSpeed: Float
	) {
		this.updateButtonStatus = updateButtonStatus;
		this.heapsPadPort = heapsPadPort;
		this.analogStickThreshold = analogStickThreshold;

		this.speedChangeButtonStatus = speedChangeButtonStatus;
		this.defaultSpeed = defaultSpeed;
		this.alternativeSpeed = alternativeSpeed;
	}
}
