package full.actor;

/**
	Functions internally used in `Army.new()`.
**/
class ArmyBuilder {
	static var defaultChunkCapacity: UInt = 64;

	public static function createPlayableActors(
		batch: h2d.SpriteBatch,
		bullets: ActorAosoa
	): PlayableActorAosoa {
		final tile = batch.tile;
		final spriteFactory = () -> new h2d.SpriteBatch.BatchElement(tile);
		final fireCallback = (
			x,
			y,
			speed,
			direction
		) -> bullets.emit(x, y, speed, direction);
		return new PlayableActorAosoa(
			1,
			1,
			batch,
			spriteFactory,
			tile.width / 2,
			tile.height / 2,
			fireCallback
		);
	}

	public static function createOnHitPlayable(aosoa: PlayableActorAosoa) {
		return (collider: Collider) -> {
			final id = ChunkEntityId.fromInt(collider.id);
			final chunk = aosoa.getChunk(id);
			final index = chunk.getReadIndex(id);
			chunk.damageEffectCoolTime[index] = 60;
		};
	}

	public static function createNonPlayableActors(
		maxEntityCount: UInt,
		batch: h2d.SpriteBatch,
		?bullets: ActorAosoa
	): NonPlayableActorAosoa {
		final chunkCapacity = UInts.min(defaultChunkCapacity, maxEntityCount);
		final chunkCount = Math.ceil(maxEntityCount / chunkCapacity);

		var aosoa: NonPlayableActorAosoa;

		final tile = batch.tile;
		final spriteFactory = () -> new h2d.SpriteBatch.BatchElement(tile);

		final bulletAosoa = Nulls.coalesce(bullets, aosoa);
		final fireCallback = (
			x,
			y,
			speed,
			direction
		) -> bulletAosoa.emit(x, y, speed, direction);

		aosoa = new NonPlayableActorAosoa(
			chunkCapacity,
			chunkCount,
			batch,
			spriteFactory,
			tile.width / 2,
			tile.height / 2,
			fireCallback
		);
		return aosoa;
	}

	public static function createOnHitNonPlayable(aosoa: NonPlayableActorAosoa) {
		return (collider: Collider) -> {
			final id = ChunkEntityId.fromInt(collider.id);
			final chunk = aosoa.getChunk(id);
			final index = chunk.getWriteIndex(id);
			chunk.deadBuffer[index] = true;
		};
	}
}
