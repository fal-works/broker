package broker.entity.heaps;

#if heaps
/**
	Basic entity class using `SpriteBatch` of heaps.
	Implements `banker.aosoa.Structure`.
**/
@:banker_verified
class BasicEntity extends broker.entity.BasicEntity {
	/**
		Factory function used in initialization of chunks.
	**/
	@:hidden
	static function spriteVectorFactory(
		chunkCapacity: Int
	): banker.vector.WritableVector<h2d.SpriteBatch.BatchElement> {
		return new banker.vector.WritableVector<h2d.SpriteBatch.BatchElement>(chunkCapacity);
	}

	/**
		Vector for storing sprites that have been used after the last synchronization.
	**/
	@:nullSafety(Off)
	@:banker_chunkLevelFinal
	@:banker_chunkLevelFactory(broker.entity.heaps.BasicEntity.spriteVectorFactory)
	var usedSprites: banker.vector.WritableVector<h2d.SpriteBatch.BatchElement>;

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
	@:banker_chunkLevelFactory(broker.entity.heaps.BasicEntity.spriteVectorFactory)
	var disusedSprites: banker.vector.WritableVector<h2d.SpriteBatch.BatchElement>;

	/**
		Number of valid elements in `disusedSprites`.
	**/
	@:banker_chunkLevel
	var disusedCount: Int = 0;

	/**
		`SpriteBatch` instance responsible for this entity.
	**/
	@:nullSafety(Off)
	@:banker_chunkLevelFinal
	var batch: h2d.SpriteBatch;

	/**
		Reflects `usedSprites` and `disusedSprites` to the `SpriteBatch`.
		Then logically clears `usedSprites` and `disusedSprites`.
	**/
	@:banker_chunkLevel
	@:banker_onSynchronize
	function synchronizeBatch() {
		final batch = this.batch;

		final disusedSprites = this.disusedSprites;
		for (i in 0...this.disusedCount) {
			@:privateAccess batch.delete(disusedSprites[i]);
		}
		this.disusedCount = 0;

		final usedSprites = this.usedSprites;
		for (i in 0...this.usedCount) {
			batch.add(usedSprites[i]);
		}
		this.usedCount = 0;
	}

	/**
		`BatchElement` instance associated to the entity.

		*Note: We're using the name "sprite" for `SpriteBatch.BatchElement` instances
		and it's not related to the deprecated type `h2d.Sprite`*.
	**/
	@:nullSafety(Off)
	@:banker_externalFactory
	@:banker_swap
	var sprite: h2d.SpriteBatch.BatchElement;

	/**
		Reflects position to sprite.
	**/
	@:banker_onCompleteSynchronize
	static function synchronizeSprite(
		sprite: h2d.SpriteBatch.BatchElement,
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
		sprite: h2d.SpriteBatch.BatchElement,
		x: banker.vector.WritableVector<Float>,
		y: banker.vector.WritableVector<Float>,
		vx: banker.vector.WritableVector<Float>,
		vy: banker.vector.WritableVector<Float>,
		i: Int,
		usedSprites: banker.vector.WritableVector<h2d.SpriteBatch.BatchElement>,
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
		sprite: h2d.SpriteBatch.BatchElement,
		x: banker.vector.WritableVector<Float>,
		y: banker.vector.WritableVector<Float>,
		vx: banker.vector.WritableVector<Float>,
		vy: banker.vector.WritableVector<Float>,
		i: Int,
		usedSprites: banker.vector.WritableVector<h2d.SpriteBatch.BatchElement>,
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
}
#end
