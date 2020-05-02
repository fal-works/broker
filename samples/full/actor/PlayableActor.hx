package full.actor;

@:banker_verified
class PlayableActor extends Actor {
	var fireCoolTime: Int = 0;

	var damageEffectCoolTime: Int = 0;

	static function assignPosition(x: Float, y: Float, output: MutablePoint): Void {
		output.set(x, y);
	}

	static function damage(
		damageEffectCoolTime: WritableVector<Int>,
		i: UInt
	): Void {
		damageEffectCoolTime[i] = 60;
	}

	static function update(
		x: WritableVector<Float>,
		y: WritableVector<Float>,
		vx: WritableVector<Float>,
		vy: WritableVector<Float>,
		i: Int,
		fire: FireCallback,
		fireCoolTime: WritableVector<Int>,
		damageEffectCoolTime: WritableVector<Int>
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

		final currentDamageEffectCoolTime = damageEffectCoolTime[i];
		if (currentDamageEffectCoolTime > 0)
			damageEffectCoolTime[i] = currentDamageEffectCoolTime - 1;
	}

	/**
		Reflects position to sprite.
	**/
	@:banker_onCompleteSynchronize
	static function synchronizeSprite(
		sprite: h2d.SpriteBatch.BatchElement,
		x: Float,
		y: Float,
		damageEffectCoolTime: Int
	): Void {
		final dx = Random.signed(1 * damageEffectCoolTime);
		sprite.x = x + dx;
		final dy = Random.signed(1 * damageEffectCoolTime);
		sprite.y = y + dy;
	}
}

@:build(banker.aosoa.Chunk.fromStructure(full.actor.PlayableActor))
@:banker_verified
class PlayableActorChunk {}
