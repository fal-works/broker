package integration;

import banker.common.MathTools.minInt;
import banker.aosoa.interfaces.AosoaConstructible;
import broker.entity.heaps.BasicEntityInitializer;
import integration.Actor.ActorInitializer;

class ActorAosoaBuilder {
	public static var defaultChunkCapacity = 64;

	/**
		Creates an `ActorAosoa` instance.
		Use this instead of `new()`.
	**/
	@:generic
	public static function create<T: ActorAosoa & AosoaConstructible>(
		maxEntityCount: Int,
		batch: h2d.SpriteBatch,
		fireCallback: FireCallback
	): T {
		final chunkCapacity = minInt(defaultChunkCapacity, maxEntityCount);
		final chunkCount = Math.ceil(maxEntityCount / chunkCapacity);

		BasicEntityInitializer.batch = batch;
		ActorInitializer.fire = fireCallback;

		final aosoa = new T(chunkCapacity, chunkCount);

		@:nullSafety(Off) {
			BasicEntityInitializer.batch = cast null;
			ActorInitializer.fire = cast null;
		}

		return aosoa;
	}
}
