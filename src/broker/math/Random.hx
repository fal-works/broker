package broker.math;

/**
	Set of functions that return random values.
**/
class Random {
	/**
		@return Random value from `0` up to (but not including) `max`.
	**/
	public static extern inline function value(max: Float): Float
		return max * Math.random();

	/**
		@return Random value from `0` up to (but not including) `max`.
	**/
	public static extern inline function int(max: Float): Int
		return Floats.toInt(value(max));

	/**
		Returns `true` or `false` randomly.
		@param probability A number between 0 and 1.
		@returns `true` with the given `probability`.
	**/
	public static extern inline function bool(probability: Float): Bool
		return Math.random() < probability;

	/**
		@return A positive or negative value randomly with a magnitude from `0` up to (but not including) `maxMagnitude`.
	**/
	public static extern inline function signed(maxMagnitude: Float): Float {
		return (if (bool(0.5)) 1.0 else -1.0) * value(maxMagnitude);
	}

	/**
		@return Random value from `0` up to (but not including) `2 * Math.PI`.
	**/
	public static extern inline function angle(): Float
		return value(Constants.TWO_PI);
}
