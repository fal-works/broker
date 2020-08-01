package broker.math;

#if broker_use_xorshift32
class RandomCore {
	static extern inline final NORMALIZE_FACTOR = 1.0 / 4294967295.0;
	static extern inline final MIN_INT_AS_FLOAT = 2147483648.0;
	static extern inline final SIGNED_NORMALIZE_FACTOR = 1.0 / MIN_INT_AS_FLOAT;

	static var x: Int = {
		final now = Date.now();
		var x = now.getDate();
		x *= now.getHours() + 1;
		x *= now.getMinutes() + 1;
		x *= now.getSeconds() + 1;
	};

	/**
		@return Random float in range `[0, 1)`.
	**/
	public static extern inline function random(): Float
		return NORMALIZE_FACTOR * (next() + MIN_INT_AS_FLOAT);

	/**
		@return Random float in range `[-1, 1)`.
	**/
	public static extern inline function randomSigned(): Float
		return SIGNED_NORMALIZE_FACTOR * next();

	/**
		Sets the seed value.
	**/
	public static extern inline function setSeed(v: Int): Void
		x = v;

	static extern inline function next(): Int {
		x = x ^ (x << 13);
		x = x ^ (x >>> 17);
		x = x ^ (x << 5);
		return x;
	}
}
#else
class RandomCore {
	/**
		@return Random float in range `[0, 1)`.
	**/
	public static extern inline function random(): Float
		return Math.random();

	/**
		Sets the seed value.
		No effect `#if !broker_use_xorshift32`.
	**/
	public static extern inline function setSeed(v: Int) {}
}
#end
