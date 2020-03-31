package integration;

import broker.entity.heaps.BasicEntityInitializer;
import broker.entity.heaps.BasicAosoa;
import integration.Actor.ActorInitializer;

/**
	AoSoA of `Actor`.
**/
@:build(banker.aosoa.macro.Builder.aosoaFromChunk(integration.Actor.ActorChunk))
class ActorAosoa implements BasicAosoa {
	/**
		Creates an `ActorAosoa` instance.
		Use this instead of `new()`.
	**/
	public static function create(
		chunkCapacity: Int,
		chunkCount: Int,
		batch: h2d.SpriteBatch,
		fireCallback: FireCallback
	) {
		BasicEntityInitializer.batch = batch;
		ActorInitializer.fire = fireCallback;

		final aosoa = new ActorAosoa(chunkCapacity, chunkCount);

		@:nullSafety(Off) {
			BasicEntityInitializer.batch = cast null;
			ActorInitializer.fire = cast null;
		}

		return aosoa;
	}
}
