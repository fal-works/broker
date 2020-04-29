package full.actor;

import broker.geometry.AxisAlignedBoundingBox;

class NonPlayableActor extends Actor {
	/**
		`true` if the entity should be disused in the next call of `update()`.
		May be set in collision detection process.
	**/
	var dead: Bool = false;

	@:banker_chunkLevelFinal
	static final habitableZone: AxisAlignedBoundingBox = {
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
		habitableZone: AxisAlignedBoundingBox,
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
}

@:build(banker.aosoa.Chunk.fromStructure(full.actor.NonPlayableActor))
class NonPlayableActorChunk {}
