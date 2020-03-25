package integration;

import hxd.Key;
import broker.input.builtin.simple.Button;

class Settings {
	public static var keyCodeMap = getDefaultKeyCodeMap();
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
}
