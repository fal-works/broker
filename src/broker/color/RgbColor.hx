package broker.color;

import sneaker.assertion.Asserter.assert;

abstract RgbColor(Int) {
	public static var WHITE: RgbColor = 0xFFFFFF;
	public static var BLACK: RgbColor = 0x000000;

	extern inline function new(v: Int) {
		#if broker_debug
		if (v < 0x000000 || v > 0xFFFFFF) {
			throw namelessError('Invalid value: ${v}');
		}
		#end

		this = v;
	}

	@:from public static extern inline function from(v: Int): RgbColor {
		assert(0x000000 <= v && v <= 0xFFFFFF);
		return new RgbColor(v);
	}

	public extern inline function int(): Int
		return this;
}
