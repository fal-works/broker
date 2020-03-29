package integration;

import integration.Actor.ActorInitializer;

/**
	AoSoA of `Actor`.
**/
@:build(banker.aosoa.macro.Builder.aosoaFrom(integration.Actor))
class ActorAosoa {
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
		ActorInitializer.batch = batch;

		final aosoa = new ActorAosoa(chunkCapacity, chunkCount);

		@:nullSafety(Off) {
			ActorInitializer.army = cast null;
			ActorInitializer.batch = cast null;
		}

		return aosoa;
	}
}
