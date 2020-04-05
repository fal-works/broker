package integration;

import hxd.Key;
import hxd.Pad;
import broker.input.builtin.simple.Button;

class Settings {
	public static var keyCodeMap = getDefaultKeyCodeMap();
	public static var buttonCodeMap = getDefaultButtonCodeMap();
	public static var highSpeed: Float = 9;
	public static var lowSpeed: Float = 3;

	static function getDefaultKeyCodeMap(): Map<Button, Array<Int>> {
		return [
			A => [Key.Z],
			B => [Key.X],
			X => [Key.SHIFT],
			Y => [Key.ESCAPE],
			D_LEFT => [Key.LEFT],
			D_UP => [Key.UP],
			D_RIGHT => [Key.RIGHT],
			D_DOWN => [Key.DOWN]
		];
	}

	static function getDefaultButtonCodeMap(): Map<Button, Array<Int>> {
		return [
			A => [Pad.DEFAULT_CONFIG.A],
			B => [Pad.DEFAULT_CONFIG.B],
			X => [Pad.DEFAULT_CONFIG.X],
			Y => [Pad.DEFAULT_CONFIG.Y],
			D_LEFT => [Pad.DEFAULT_CONFIG.dpadLeft],
			D_UP => [Pad.DEFAULT_CONFIG.dpadUp],
			D_RIGHT => [Pad.DEFAULT_CONFIG.dpadRight],
			D_DOWN => [Pad.DEFAULT_CONFIG.dpadDown]
		];
	}
}
