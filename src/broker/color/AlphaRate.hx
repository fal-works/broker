package broker.color;

abstract AlphaRate(Float) from Float {
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
}
