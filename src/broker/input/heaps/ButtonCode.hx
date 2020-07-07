package broker.input.heaps;

import hxd.Pad;

/**
	Value that specifies a button of physical gamepad.
**/
abstract ButtonCode(Int) {
	public static var A = from(Pad.DEFAULT_CONFIG.A);
	public static var B = from(Pad.DEFAULT_CONFIG.B);
	public static var X = from(Pad.DEFAULT_CONFIG.X);
	public static var Y = from(Pad.DEFAULT_CONFIG.Y);
	public static var LEFT = from(Pad.DEFAULT_CONFIG.dpadLeft);
	public static var UP = from(Pad.DEFAULT_CONFIG.dpadUp);
	public static var RIGHT = from(Pad.DEFAULT_CONFIG.dpadRight);
	public static var DOWN = from(Pad.DEFAULT_CONFIG.dpadDown);
	public static var LB = from(Pad.DEFAULT_CONFIG.LB);
	public static var RB = from(Pad.DEFAULT_CONFIG.RB);
	public static var BACK = from(Pad.DEFAULT_CONFIG.back);
	public static var START = from(Pad.DEFAULT_CONFIG.start);

	/**
		Casts `code` to `ButtonCode`.
	**/
	public static extern inline function from(code: Int): ButtonCode
		return new ButtonCode(code);

	/**
		The integer value of `this` keycode.
	**/
	public var code(get, never): Int;

	extern inline function new(code: Int)
		this = code;

	extern inline function get_code()
		return this;
}
