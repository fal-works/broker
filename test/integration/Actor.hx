package integration;

import banker.vector.WritableVector as Vec;

class Actor implements banker.aosoa.Structure {
	@:banker.chunkLevelFinal
	@:banker.chunkLevelFactory(ActorTools.spriteVectorFactory)
	var usedSprites: Vec<Sprite>;

	@:banker.chunkLevel
	var usedCount: Int = 0;

	@:banker.chunkLevelFinal
	@:banker.chunkLevelFactory(ActorTools.spriteVectorFactory)
	var disusedSprites: Vec<Sprite>;

	@:banker.chunkLevel
	var disusedCount: Int = 0;

	@:banker.useEntity
	static function use(
		sprite: Sprite,
		x: Vec<Float>,
		y: Vec<Float>,
		vx: Vec<Float>,
		vy: Vec<Float>,
		i: Int,
		usedSprites: Vec<Sprite>,
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

	static function update(
		sprite: Sprite,
		x: Vec<Float>,
		y: Vec<Float>,
		vx: Float,
		vy: Float,
		i: Int,
		disuse: Bool,
		disusedSprites: Vec<Sprite>,
		disusedCount: Int
	): Void {
		final nextX = x[i] + vx;
		final nextY = y[i] + vy;
		x[i] = nextX;
		y[i] = nextY;

		if (nextX < 0 || nextX > 800 || nextY < 0 || nextY > 600) {
			disuse = true;
			disusedSprites[disusedCount] = sprite;
			++disusedCount;
		}
	}

	function onSynchronize() {
		final disusedSprites = this.disusedSprites;
		for (i in 0...this.disusedCount) disusedSprites[i].kill();
		this.disusedCount = 0;

		final usedSprites = this.usedSprites;
		for (i in 0...this.usedCount)
			ActorRenderer.batch.add(usedSprites[i]);
		this.usedCount = 0;
	}

	static function updateSprite(
		sprite: Sprite,
		x: Float,
		y: Float
	): Void {
		sprite.x = x;
		sprite.y = y;
	}

	@:banker.factory(ActorTools.spriteFactory)
	@:banker.swap
	var sprite: Sprite;

	var x: Float = 0;
	var y: Float = 0;
	var vx: Float = 0;
	var vy: Float = 0;
}

class ActorTools {
	public static function spriteVectorFactory(chunkCapacity: Int): Vec<Sprite>
		return new Vec<Sprite>(chunkCapacity);

	public static function spriteFactory(): Sprite
		return new Sprite(ActorRenderer.tile);
}
