package broker.entity.heaps;

#if heaps
/**
	Basic entity class using `SpriteBatch` of heaps.
	Implements `banker.aosoa.Structure`.
**/
@:banker_verified
class BasicEntity extends broker.entity.BasicEntity {
	/**
		Vector for storing sprites that have been used after the last synchronization.
	**/
	@:nullSafety(Off)
	@:banker_chunkLevelFinal
	@:banker_chunkLevelFactory(broker.entity.heaps.BasicEntityInitializer.spriteVectorFactory)
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
	@:banker_chunkLevelFactory(broker.entity.heaps.BasicEntityInitializer.spriteVectorFactory)
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

	/**
		Updates position by adding current velocity.
	**/
	static function updatePosition(
		sprite: h2d.SpriteBatch.BatchElement,
		x: banker.vector.WritableVector<Float>,
		y: banker.vector.WritableVector<Float>,
		vx: Float,
		vy: Float,
		i: Int
	): Void {
		x[i] += vx;
		y[i] += vy;
	}

	/**
		Reflects `usedSprites` and `disusedSprites` to the `SpriteBatch`.
		Then logically clears `usedSprites` and `disusedSprites`.
	**/
	function onSynchronize() {
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
		Reflects position to sprite.
	**/
	static function updateSprite(
		sprite: h2d.SpriteBatch.BatchElement,
		x: Float,
		y: Float
	): Void {
		sprite.x = x;
		sprite.y = y;
	}

	/**
		`BatchElement` instance associated to the entity.

		*Note: We're using the name "sprite" for `SpriteBatch.BatchElement` instances
		and it's not related to the deprecated type `h2d.Sprite`*.
	**/
	@:nullSafety(Off)
	@:banker_externalFactory()
	@:banker_swap
	var sprite: h2d.SpriteBatch.BatchElement;
}
#end
