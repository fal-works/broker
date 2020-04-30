package full.actor;

class NonPlayableActor extends Actor {
	/**
		`true` if the entity should be disused in the next call of `update()`.
		May be set in collision detection process.
	**/
	var dead: Bool = false;

	@:banker_chunkLevelFinal
	static final habitableZone: Aabb = {
		leftX: 0 - 64,
		topY: 0 - 64,
		rightX: 800 + 64,
		bottomY: 600 + 64
	};

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
		habitableZone: Aabb,
		dead: WritableVector<Bool>
	): Void {
		final nextX = x[i] + vx;
		final nextY = y[i] + vy;
		x[i] = nextX;
		y[i] = nextY;

		if (dead[i] || !habitableZone.containsPoint(nextX, nextY)) {
			disuse = true;
			disusedSprites[disusedCount] = sprite;
			++disusedCount;
			dead[i] = false;
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
class NonPlayableActorChunk {}
