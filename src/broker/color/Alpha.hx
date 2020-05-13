package broker.color;

abstract Alpha(Float) {
	/**
		Casts `value` to `Alpha` (clamped to 0.0-1.0).
	**/
	@:from public static extern inline function from(value: Float): Alpha {
		return new Alpha(if (value < 0.0) 0.0 else if (value > 1.0) 1.0 else value);
	}

	/**
		Casts `value` to `Alpha` without clamping.
	**/
	public static extern inline function fromUnsafe(value: Float): Alpha {
		return new Alpha(value);
	}

	@:op(A + B)
	static extern inline function plus(a: Alpha, b: Alpha): Alpha
		return from(a.float() + b.float());

	@:op(A + B) @:commutative
	static extern inline function plusRate(a: Alpha, b: AlphaRate): Alpha
		return from(a.float() + b.float());

	@:op(A - B)
	static extern inline function minus(a: Alpha, b: Alpha): Alpha
		return from(a.float() - b.float());

	@:op(A - B) @:commutative
	static extern inline function minusRate(a: Alpha, b: AlphaRate): Alpha
		return from(a.float() - b.float());

	@:op(A * B) static extern inline function mult(a: Alpha, b: Alpha): Alpha
		return from(a.float() * b.float());

	@:op(A * B) @:commutative
	static extern inline function multFloat(a: Alpha, b: Float): Alpha
		return from(a.float() * b);

	/**
		Casts `this` to `Float`.
	**/
	public extern inline function float(): Float
		return this;

	/**
		@return `true` if `this == 0.0`.
	**/
	public extern inline function isZero(): Bool
		return this == 0.0;

	/**
		@return `true` if `this == 1.0`.
	**/
	public extern inline function isOne(): Bool
		return this == 1.0;

	extern inline function new(v: Float)
		this = v;
}
