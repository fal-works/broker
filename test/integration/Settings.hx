package integration;

import hxd.Key;
import hxd.Pad;
import broker.input.builtin.simple.Button;

class Settings {
	public static var keyCodeMap = getDefaultKeyCodeMap();
	public static var buttonCodeMap = getDefaultButtonCodeMap();
	public static var highSpeed: Float = 9;
	public static var lowSpeed: Float = 3;

	static function getDefaultKeyCodeMap(): Map<Button, Array<Int>>
		return [
			A => [Key.Z],
			B => [Key.X],
			X => [Key.SHIFT],
			Y => [Key.ESCAPE],
			LEFT => [Key.LEFT],
			UP => [Key.UP],
			RIGHT => [Key.RIGHT],
			DOWN => [Key.DOWN]
		];

	static function getDefaultButtonCodeMap(): Map<Button, Array<Int>>
		return [
			A => [Pad.DEFAULT_CONFIG.A],
			B => [Pad.DEFAULT_CONFIG.B],
			X => [Pad.DEFAULT_CONFIG.X],
			Y => [Pad.DEFAULT_CONFIG.Y],
			LEFT => [Pad.DEFAULT_CONFIG.dpadLeft],
			UP => [Pad.DEFAULT_CONFIG.dpadUp],
			RIGHT => [Pad.DEFAULT_CONFIG.dpadRight],
			DOWN => [Pad.DEFAULT_CONFIG.dpadDown]
		];

}
