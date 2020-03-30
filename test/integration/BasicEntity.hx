package integration;

@:banker.doNotBuild
class BasicEntity implements banker.aosoa.Structure {
	@:banker.chunkLevelFinal
	@:banker.chunkLevelFactory(integration.BasicEntityInitializer.spriteVectorFactory)
	var usedSprites: banker.vector.WritableVector<Sprite>;

	@:banker.chunkLevel
	var usedCount: Int = 0;

	@:banker.chunkLevelFinal
	@:banker.chunkLevelFactory(integration.BasicEntityInitializer.spriteVectorFactory)
	var disusedSprites: banker.vector.WritableVector<Sprite>;

	@:banker.chunkLevel
	var disusedCount: Int = 0;

	@:banker.chunkLevel
	final batch: h2d.SpriteBatch = integration.BasicEntityInitializer.batch;

	@:banker.useEntity
	static function emit(
		sprite: Sprite,
		x: banker.vector.WritableVector<Float>,
		y: banker.vector.WritableVector<Float>,
		vx: banker.vector.WritableVector<Float>,
		vy: banker.vector.WritableVector<Float>,
		i: Int,
		usedSprites: banker.vector.WritableVector<Sprite>,
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

	static function updatePosition(
		sprite: Sprite,
		x: banker.vector.WritableVector<Float>,
		y: banker.vector.WritableVector<Float>,
		vx: Float,
		vy: Float,
		i: Int,
		disuse: Bool,
		disusedSprites: banker.vector.WritableVector<Sprite>,
		disusedCount: Int
	): Void {
		x[i] += vx;
		y[i] += vy;
	}

	function onSynchronize() {
		final disusedSprites = this.disusedSprites;
		for (i in 0...this.disusedCount) disusedSprites[i].kill();
		this.disusedCount = 0;

		final usedSprites = this.usedSprites;
		final batch = this.batch;
		for (i in 0...this.usedCount) batch.add(usedSprites[i]);
		this.usedCount = 0;
	}

	static function updateSprite(
		sprite: Sprite,
		x: Float,
		y: Float,
		halfTileWidth: Float,
		halfTileHeight: Float
	): Void {
		sprite.x = x - halfTileWidth;
		sprite.y = y - halfTileHeight;
	}

	@:banker.factory(integration.BasicEntityInitializer.spriteFactory)
	@:banker.swap
	var sprite: Sprite;

	var x: Float = 0;
	var y: Float = 0;
	var vx: Float = 0;
	var vy: Float = 0;
}
