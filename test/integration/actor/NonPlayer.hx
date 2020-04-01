package integration.actor;

import banker.vector.WritableVector as Vec;
import h2d.SpriteBatch.BatchElement;

class NonPlayer extends Actor {
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
}

@:build(banker.aosoa.Chunk.fromStructure(integration.actor.NonPlayer))
class NonPlayerChunk {}
