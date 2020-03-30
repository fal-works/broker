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
		army: ActorArmy,
		chunkCapacity: Int,
		chunkCount: Int,
		batch: h2d.SpriteBatch
	) {
		ActorInitializer.army = army;
		BasicEntityInitializer.batch = batch;

		final aosoa = new ActorAosoa(chunkCapacity, chunkCount);

		@:nullSafety(Off) {
			ActorInitializer.army = cast null;
			BasicEntityInitializer.batch = cast null;
		}

		return aosoa;
	}
}
