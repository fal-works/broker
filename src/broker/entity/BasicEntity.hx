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
		Uses a new available entity and sets initial position and velocity.
		@param initialX
		@param initialY
		@param initialVx
		@param initialVy
	**/
	@:banker_useEntity
	static function use(
		x: banker.vector.WritableVector<Float>,
		y: banker.vector.WritableVector<Float>,
		vx: banker.vector.WritableVector<Float>,
		vy: banker.vector.WritableVector<Float>,
		i: Int,
		initialX: Float,
		initialY: Float,
		initialVx: Float,
		initialVy: Float
	): Void {
		x[i] = initialX;
		y[i] = initialY;
		vx[i] = initialVx;
		vy[i] = initialVy;
	}

	/**
		Uses a new available entity and sets initial position and velocity.
		@param initialX
		@param initialY
		@param speed
		@param direction
	**/
	@:banker_useEntity
	static function emit(
		x: banker.vector.WritableVector<Float>,
		y: banker.vector.WritableVector<Float>,
		vx: banker.vector.WritableVector<Float>,
		vy: banker.vector.WritableVector<Float>,
		i: Int,
		initialX: Float,
		initialY: Float,
		speed: Float,
		direction: Float
	): Void {
		x[i] = initialX;
		y[i] = initialY;
		vx[i] = speed * Math.cos(direction);
		vy[i] = speed * Math.sin(direction);
	}

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
