package integration;

import banker.common.MathTools.minInt;

class ActorAosoaBuilder {
	public static var defaultChunkCapacity = 64;

	/**
		Creates an `ActorAosoa` instance.
	**/
	public static function create(
		maxEntityCount: Int,
		batch: h2d.SpriteBatch,
		fireCallback: FireCallback
	): ActorAosoa {
		final chunkCapacity = minInt(defaultChunkCapacity, maxEntityCount);
		final chunkCount = Math.ceil(maxEntityCount / chunkCapacity);

		final tile = batch.tile;
		final spriteFactory = () -> new h2d.SpriteBatch.BatchElement(tile);
		final aosoa = new ActorAosoa(
			chunkCapacity,
			chunkCount,
			batch,
			spriteFactory,
			fireCallback
		);

		return aosoa;
	}
}
