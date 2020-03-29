package integration;

import h2d.SpriteBatch;
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

	@:banker.chunkLevel
	final batch: SpriteBatch = ActorTools.batch;

	@:banker.chunkLevel
	final army: ActorArmy = ActorTools.army;

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

@:allow(integration.Actor)
class ActorTools {
	public static var batch: h2d.SpriteBatch;
	public static var army: ActorArmy;

	public static function spriteVectorFactory(chunkCapacity: Int): Vec<Sprite> {
		return new Vec<Sprite>(chunkCapacity);
	}

	public static function spriteFactory(): Sprite {
		return new Sprite(ActorTools.batch.tile);
	}

	public static function createAosoa(army: ActorArmy, chunkCapacity: Int, chunkCount: Int, batch: h2d.SpriteBatch) {
		ActorTools.army = army;
		ActorTools.batch = batch;

		final aosoa = Actor.createAosoa(chunkCapacity, chunkCount);

		@:nullSafety(Off) ActorTools.army = cast null;
		@:nullSafety(Off) ActorTools.batch = cast null;

		return aosoa;
	}
}
