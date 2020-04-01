package integration.actor;

import banker.vector.WritableVector as Vec;
import h2d.SpriteBatch.BatchElement;

class Player extends Actor {
	static function update(
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

@:build(banker.aosoa.Chunk.fromStructure(integration.actor.Player))
class PlayerChunk {}
