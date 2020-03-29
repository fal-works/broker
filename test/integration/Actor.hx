package integration;

import h2d.SpriteBatch;
import banker.vector.WritableVector as Vec;

@:banker.doNotDefineAosoa
class Actor implements banker.aosoa.Structure {
	@:banker.chunkLevelFinal
	@:banker.chunkLevelFactory(ActorInitializer.spriteVectorFactory)
	var usedSprites: Vec<Sprite>;

	@:banker.chunkLevel
	var usedCount: Int = 0;

	@:banker.chunkLevelFinal
	@:banker.chunkLevelFactory(ActorInitializer.spriteVectorFactory)
	var disusedSprites: Vec<Sprite>;

	@:banker.chunkLevel
	var disusedCount: Int = 0;

	@:banker.chunkLevel
	final batch: SpriteBatch = ActorInitializer.batch;

	@:banker.chunkLevel
	final army: ActorArmy = ActorInitializer.army;

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

	static function moveByGamepad(
		x: Vec<Float>,
		y: Vec<Float>,
		vx: Vec<Float>,
		vy: Vec<Float>,
		i: Int,
		army: ActorArmy
	): Void {
		final stick = integration.global.Gamepad.stick;
		final dx = stick.x;
		final dy = stick.y;
		final nextX = x[i] + dx;
		final nextY = y[i] + dy;
		x[i] = nextX;
		y[i] = nextY;
		vx[i] = dx;
		vy[i] = dx;

		if (integration.global.Gamepad.buttons.A.isPressed)
			army.bullets.aosoa.use(nextX, nextY, 10, Math.random() * 2 * Math.PI);
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

	@:banker.factory(ActorInitializer.spriteFactory)
	@:banker.swap
	var sprite: Sprite;

	var x: Float = 0;
	var y: Float = 0;
	var vx: Float = 0;
	var vy: Float = 0;
}

/**
	Stores values and functions used when creating an AoSoA of `Actor`.
**/
class ActorInitializer {
	/**
		Value used in initialization of `ActorChunk`.
		Should be set every time an AoSoA of `Actor` is created.
	**/
	public static var army: ActorArmy;

	/**
		Value used in initialization of `ActorChunk`.
		Should be set every time an AoSoA of `Actor` is created.
	**/
	public static var batch: h2d.SpriteBatch;

	/**
		Factory function used in initialization of `ActorChunk`.
	**/
	public static function spriteVectorFactory(chunkCapacity: Int): Vec<Sprite> {
		return new Vec<Sprite>(chunkCapacity);
	}

	/**
		Factory function used in initialization of `Actor` entities.
	**/
	public static function spriteFactory(): Sprite {
		return new Sprite(batch.tile);
	}
}
