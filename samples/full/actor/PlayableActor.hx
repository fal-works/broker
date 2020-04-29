package full.actor;

import full.Global;

class PlayableActor extends Actor {
	var fireCoolTime: Int = 0;

	static function update(
		x: WritableVector<Float>,
		y: WritableVector<Float>,
		vx: WritableVector<Float>,
		vy: WritableVector<Float>,
		i: Int,
		fire: FireCallback,
		fireCoolTime: WritableVector<Int>
	): Void {
		final gamepad = Global.gamepad;

		final stick = gamepad.stick;
		final dx = stick.x;
		final dy = stick.y;
		final nextX = x[i] + dx;
		final nextY = y[i] + dy;
		x[i] = nextX;
		y[i] = nextY;
		vx[i] = dx;
		vy[i] = dx;

		final currentFireCoolTime = fireCoolTime[i];
		if (currentFireCoolTime > 0) {
			fireCoolTime[i] = currentFireCoolTime - 1;
		} else if ((gamepad.buttons).A.isPressed) {
			fire(nextX, nextY, 15, 1.5 * Math.PI);
			fireCoolTime[i] = 4;
		}
	}
}

@:build(banker.aosoa.Chunk.fromStructure(full.actor.PlayableActor))
class PlayableActorChunk {}
