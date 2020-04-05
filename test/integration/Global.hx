package integration;

import broker.input.heaps.HeapsPadMultitap;

class Global {
	public static final defaultGamepadBuilder: GamepadBuilder = {
		keyCodeMap: [
			A => [hxd.Key.Z],
			B => [hxd.Key.X],
			X => [hxd.Key.SHIFT],
			Y => [hxd.Key.ESCAPE],
			D_LEFT => [hxd.Key.LEFT],
			D_UP => [hxd.Key.UP],
			D_RIGHT => [hxd.Key.RIGHT],
			D_DOWN => [hxd.Key.DOWN]
		],
		padButtonCodeMap: [
			A => [hxd.Pad.DEFAULT_CONFIG.A],
			B => [hxd.Pad.DEFAULT_CONFIG.B],
			X => [hxd.Pad.DEFAULT_CONFIG.X],
			Y => [hxd.Pad.DEFAULT_CONFIG.Y],
			D_LEFT => [hxd.Pad.DEFAULT_CONFIG.dpadLeft],
			D_UP => [hxd.Pad.DEFAULT_CONFIG.dpadUp],
			D_RIGHT => [hxd.Pad.DEFAULT_CONFIG.dpadRight],
			D_DOWN => [hxd.Pad.DEFAULT_CONFIG.dpadDown]
		],
		heapsPadPort: HeapsPadMultitap.ports[0],
		analogStickThreshold: 0.1,
		speedChangeButton: X,
		defaultSpeed: 9,
		alternativeSpeed: 3
	};

	public static var gamepad(default, null) = defaultGamepadBuilder.build();
}
