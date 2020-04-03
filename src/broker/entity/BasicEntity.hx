package broker.entity;

/**
	Basic entity with position and velocity.
	Implements `banker.aosoa.Structure`.
**/
@:banker_verified
class BasicEntity implements banker.aosoa.Structure {
	/**
		X-component of the position.
	**/
	var x: Float = 0;

	/**
		Y-component of the position.
	**/
	var y: Float = 0;

	/**
		X-component of the velocity.
	**/
	var vx: Float = 0;

	/**
		Y-component of the velocity.
	**/
	var vy: Float = 0;

	/**
		Updates position by adding current velocity.
	**/
	static function updatePosition(
		x: banker.vector.WritableVector<Float>,
		y: banker.vector.WritableVector<Float>,
		vx: Float,
		vy: Float,
		i: Int
	): Void {
		x[i] += vx;
		y[i] += vy;
	}
}
