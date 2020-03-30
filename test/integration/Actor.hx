package integration;

import banker.vector.WritableVector as Vec;

@:banker.doNotDefineAosoa
class Actor extends BasicEntity {
	@:banker.chunkLevel
	final army: ActorArmy = ActorInitializer.army;

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
			army.bullets.aosoa.emit(nextX, nextY, 10, Math.random() * 2 * Math.PI);
	}
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
}
