package broker.math;

/**
	Set of functions that return random values.
**/
class Random {
	/**
		@return Random value from `0` up to (but not including) `1`.
	**/
	public static extern inline function random(): Float
		return RandomCore.random();

	/**
		@return Random value from `0` up to (but not including) `max`.
	**/
	public static extern inline function value(max: Float): Float
		return max * random();

	/**
		@return Random value from `min` up to (but not including) `max`.
	**/
	public static extern inline function between(min: Float, max: Float): Float
		return min + value(max - min);

	/**
		@return Random value from `0` up to (but not including) `max`.
	**/
	public static extern inline function int(max: Float): Int
		return Floats.toInt(value(max));

	/**
		@return Random value from `min` up to (but not including) `max`.
	**/
	public static extern inline function intBetween(min: Int, max: Int): Int
		return min + int(max - min);

	/**
		Returns `true` or `false` randomly.
		@param probability A number between 0 and 1.
		@returns `true` with the given `probability`.
	**/
	public static extern inline function bool(probability: Float): Bool
		return Math.random() < probability;

	/**
		@return Random value in range `[-maxMagnitude, maxMagnitude)`.
	**/
	public static extern inline function signed(maxMagnitude: Float): Float {
		#if broker_use_xorshift32
		return maxMagnitude * RandomCore.randomSigned();
		#else
		return maxMagnitude * (-1.0 + random() * 2.0);
		#end
	}

	/**
		@return Random value from `0` up to (but not including) `2 * PI`.
	**/
	public static extern inline function angle(): Float
		return value(Constants.TWO_PI);

	/**
		@return Random value from `-PI` up to (but not including) `+PI`.
	**/
	public static extern inline function signedAngle(): Float {
		#if broker_use_xorshift32
		return signed(Constants.PI);
		#else
		return Constants.MINUS_PI + angle();
		#end
	}
}
