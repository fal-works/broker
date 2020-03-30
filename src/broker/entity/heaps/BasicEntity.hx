package broker.entity.heaps;

#if heaps
/**
	Basic entity class using `SpriteBatch` of heaps.
**/
class BasicEntity extends broker.entity.BasicEntity implements banker.aosoa.Structure {
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
	@:banker_chunkLevel
	final batch: h2d.SpriteBatch = broker.entity.heaps.BasicEntityInitializer.batch;

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
		y: Float,
		halfTileWidth: Float,
		halfTileHeight: Float
	): Void {
		sprite.x = x - halfTileWidth;
		sprite.y = y - halfTileHeight;
	}

	/**
		`BatchElement` associated to the entity.
	**/
	@:nullSafety(Off)
	@:banker_factory(broker.entity.heaps.BasicEntityInitializer.spriteFactory)
	@:banker_swap
	var sprite: h2d.SpriteBatch.BatchElement;
}
#end
