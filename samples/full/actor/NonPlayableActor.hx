package full.actor;

@:banker_verified
class NonPlayableActor extends Actor {
	/**
		`true` if the entity should be disused in the next call of `update()`.
		May be set in collision detection process.
	**/
	var dead: Bool = false;

	static function update(
		sprite: BatchElement,
		x: WritableVector<Float>,
		y: WritableVector<Float>,
		vx: Float,
		vy: Float,
		i: Int,
		disuse: Bool,
		disusedSprites: WritableVector<BatchElement>,
		disusedCount: Int,
		dead: WritableVector<Bool>
	): Void {
		final currentX = x[i];
		final currentY = y[i];

		if (dead[i] || !HabitableZone.containsPoint(currentX, currentY)) {
			disuse = true;
			disusedSprites[disusedCount] = sprite;
			++disusedCount;
			if (dead[i]) {
				Global.emitParticles(currentX, currentY, 2, 16, 32);
				dead[i] = false;
			}
		} else {
			x[i] = currentX + vx;
			y[i] = currentY + vy;
		}
	}

	static function mayFire(
		x: Float,
		y: Float,
		fire: FireCallback
	): Void {
		if (y < 240 && Random.bool(0.01)) {
			final playerPosition = Global.playerPosition;
			fire(
				x,
				y,
				4,
				Math.atan2(playerPosition.y() - y, playerPosition.x() - x)
			);
		}
	}
}

@:build(banker.aosoa.Chunk.fromStructure(full.actor.NonPlayableActor))
@:banker_verified
class NonPlayableActorChunk {}
