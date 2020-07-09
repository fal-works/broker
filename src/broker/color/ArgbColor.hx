package broker.color;

import sneaker.assertion.Asserter.assert;

abstract ArgbColor(Int) {
	public static extern inline final TRANSPARENT: ArgbColor = new ArgbColor(0x00000000);
	public static extern inline final WHITE: ArgbColor = new ArgbColor(0xFFFFFFFF);
	public static extern inline final BLACK: ArgbColor = new ArgbColor(0xFF000000);
	static extern inline final ALPHA_FACTOR: Float = 1.0 / 255.0;

	@:from public static extern inline function from(value: Int): ArgbColor {
		assert(value & 0xFFFFFFFF == value);
		return new ArgbColor(value);
	}

	public extern inline function int(): Int
		return this;

	public extern inline function getRgb(): RgbColor
		return this & 0xFFFFFF;

	public extern inline function getAlpha(): Alpha {
		return (this >>> 24) * ALPHA_FACTOR;
	}

	extern inline function new(v: Int)
		this = v;
}
