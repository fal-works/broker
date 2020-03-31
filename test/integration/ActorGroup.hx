package integration;

import banker.common.MathTools.minInt;
import broker.entity.heaps.EntityGroup;

/**
	Wrapper of `ActorAosoa`.
**/
class ActorGroup extends EntityGroup<ActorAosoa> {
	public static var defaultChunkCapacity = 64;

	public function new(
		maxEntityCount: Int,
		batch: h2d.SpriteBatch,
		fireCallback: FireCallback
	) {
		final chunkCapacity = minInt(defaultChunkCapacity, maxEntityCount);
		final chunkCount = Math.ceil(maxEntityCount / chunkCapacity);
		final aosoa = ActorAosoa.create(chunkCapacity, chunkCount, batch, fireCallback);

		super(aosoa, batch.tile);
	}
}
