package full.particle;

import broker.entity.heaps.BasicEntity;

@:banker_verified
class Particle extends BasicEntity {
	var visibilityRatio: Float = 1.0;
	var rotationAngle: Float = 0.0;
	var rotationAngleVelocity: Float = 0.1;

	@:banker_useEntity
	static function emit(
		sprite: h2d.SpriteBatch.BatchElement,
		x: WritableVector<Float>,
		y: WritableVector<Float>,
		vx: WritableVector<Float>,
		vy: WritableVector<Float>,
		visibilityRatio: WritableVector<Float>,
		i: Int,
		usedSprites: WritableVector<h2d.SpriteBatch.BatchElement>,
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
		visibilityRatio[i] = 1.0;
		usedSprites[usedCount] = sprite;
		++usedCount;
	}

	static function update(
		sprite: BatchElement,
		x: WritableVector<Float>,
		y: WritableVector<Float>,
		vx: WritableVector<Float>,
		vy: WritableVector<Float>,
		rotationAngle: WritableVector<Float>,
		rotationAngleVelocity: Float,
		visibilityRatio: WritableVector<Float>,
		i: Int,
		disuse: Bool,
		disusedSprites: WritableVector<BatchElement>,
		disusedCount: Int
	): Void {
		final currentX = x[i];
		final currentY = y[i];
		final currentVisibilityRatio = visibilityRatio[i];

		if (currentVisibilityRatio <= 0.02
			|| !HabitableZone.containsPoint(currentX, currentY)) {
			visibilityRatio[i] = 1.0;
			disuse = true;
			disusedSprites[disusedCount] = sprite;
			++disusedCount;
		} else {
			final currentVx = vx[i];
			final currentVy = vy[i];
			x[i] = currentX + currentVx;
			y[i] = currentY + currentVy;
			vx[i] = 0.92 * currentVx;
			vy[i] = 0.92 * currentVy + 0.2;
			rotationAngle[i] += rotationAngleVelocity;
			visibilityRatio[i] = currentVisibilityRatio - 0.02;
		}
	}

	/**
		Reflects position to sprite.
	**/
	@:banker_onCompleteSynchronize
	static function synchronizeSprite(
		sprite: h2d.SpriteBatch.BatchElement,
		x: Float,
		y: Float,
		rotationAngle: Float,
		visibilityRatio: Float
	): Void {
		sprite.x = x;
		sprite.y = y;
		sprite.rotation = rotationAngle;
		sprite.scale = 0.25 + 0.75 * visibilityRatio;
		sprite.alpha = visibilityRatio;
	}
}

@:build(banker.aosoa.Chunk.fromStructure(full.particle.Particle))
@:banker_verified
class ParticleChunk {}
