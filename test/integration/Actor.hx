package integration;

import banker.vector.WritableVector as Vec;
import broker.entity.heaps.BasicEntity;
import h2d.SpriteBatch.BatchElement;

class Actor extends BasicEntity {
	@:banker_chunkLevelFinal
	var fire: FireCallback;

	static function update(
		sprite: BatchElement,
		x: Vec<Float>,
		y: Vec<Float>,
		vx: Float,
		vy: Float,
		i: Int,
		disuse: Bool,
		disusedSprites: Vec<BatchElement>,
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
		fire: FireCallback
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
			fire(nextX, nextY, 10, Math.random() * 2 * Math.PI);
	}
}

@:build(banker.aosoa.Chunk.fromStructure(integration.Actor))
class ActorChunk {}
