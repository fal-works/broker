package broker.entity;

/**
	Basic entity class using `broker.draw.BatchDraw`.
	Implements `banker.aosoa.Structure`.
**/
@:banker_verified
class BasicBatchEntity extends broker.entity.BasicEntity {
	/**
		Factory function used in initialization of chunks.
	**/
	@:banker_hidden
	static function spriteVectorFactory(
		chunkCapacity: Int
	): banker.vector.WritableVector<broker.draw.BatchSprite> {
		return new banker.vector.WritableVector<broker.draw.BatchSprite>(chunkCapacity);
	}

	/**
		Vector for storing sprites that have been used after the last synchronization.
	**/
	@:nullSafety(Off)
	@:banker_chunkLevelFinal
	@:banker_chunkLevelFactory(broker.entity.BasicBatchEntity.spriteVectorFactory)
	var usedSprites: banker.vector.WritableVector<broker.draw.BatchSprite>;

	/**
		Number of valid elements in `usedSprites`.
	**/
	@:banker_chunkLevel
	var usedCount: Int = 0;

	/**
		Vector for storing sprites that have been disused after the last synchronization.
	**/
	@:nullSafety(Off)
	@:banker_chunkLevelFinal
	@:banker_chunkLevelFactory(broker.entity.BasicBatchEntity.spriteVectorFactory)
	var disusedSprites: banker.vector.WritableVector<broker.draw.BatchSprite>;

	/**
		Number of valid elements in `disusedSprites`.
	**/
	@:banker_chunkLevel
	var disusedCount: Int = 0;

	/**
		`BatchDraw` instance responsible for this entity.
	**/
	@:nullSafety(Off)
	@:banker_chunkLevelFinal
	var batch: broker.draw.BatchDraw;

	/**
		Reflects `usedSprites` and `disusedSprites` to the `BatchDraw`.
		Then logically clears `usedSprites` and `disusedSprites`.
	**/
	@:banker_chunkLevel
	@:banker_onSynchronize
	function synchronizeBatch() {
		final batch = this.batch;

		batch.removeSprites(this.disusedSprites, this.disusedCount);
		this.disusedCount = 0;

		batch.addSprites(this.usedSprites, this.usedCount);
		this.usedCount = 0;
	}

	/**
		`BatchSprite` instance associated to the entity.
	**/
	@:nullSafety(Off)
	@:banker_externalFactory
	@:banker_swap
	var sprite: broker.draw.BatchSprite;

	/**
		Reflects position to sprite.
	**/
	@:banker_onCompleteSynchronize
	static function synchronizeSprite(
		sprite: broker.draw.BatchSprite,
		x: Float,
		y: Float
	): Void {
		sprite.x = x;
		sprite.y = y;
	}

	/**
		Uses a new available entity and sets initial position and velocity.
		@param initialX
		@param initialY
		@param initialVx
		@param initialVy
	**/
	@:banker_useEntity
	static function use(
		sprite: broker.draw.BatchSprite,
		x: banker.vector.WritableVector<Float>,
		y: banker.vector.WritableVector<Float>,
		vx: banker.vector.WritableVector<Float>,
		vy: banker.vector.WritableVector<Float>,
		i: Int,
		usedSprites: banker.vector.WritableVector<broker.draw.BatchSprite>,
		usedCount: Int,
		initialX: Float,
		initialY: Float,
		initialVx: Float,
		initialVy: Float
	): Void {
		x[i] = initialX;
		y[i] = initialY;
		vx[i] = initialVx;
		vy[i] = initialVy;
		usedSprites[usedCount] = sprite;
		++usedCount;
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
		sprite: broker.draw.BatchSprite,
		x: banker.vector.WritableVector<Float>,
		y: banker.vector.WritableVector<Float>,
		vx: banker.vector.WritableVector<Float>,
		vy: banker.vector.WritableVector<Float>,
		i: Int,
		usedSprites: banker.vector.WritableVector<broker.draw.BatchSprite>,
		usedCount: Int,
		initialX: Float,
		initialY: Float,
		speed: Float,
		direction: Float
	): Void {
		x[i] = initialX;
		y[i] = initialY;
		vx[i] = speed * Math.cos(direction);
		vy[i] = speed * Math.sin(direction);
		usedSprites[usedCount] = sprite;
		++usedCount;
	}

	/**
		Disuses all entities currently in use.
	**/
	static function disuseAll(
		sprite: broker.draw.BatchSprite,
		i: Int,
		disuse: Bool,
		disusedSprites: banker.vector.WritableVector<broker.draw.BatchSprite>,
		disusedCount: Int
	): Void {
		disuse = true;
		disusedSprites[disusedCount] = sprite;
		++disusedCount;
	}
}
