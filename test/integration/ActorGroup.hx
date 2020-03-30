package integration;

import banker.common.MathTools.minInt;
import broker.entity.heaps.EntityGroup;

/**
	Wrapper of `ActorAosoa`.
**/
class ActorGroup extends EntityGroup<ActorAosoa> {
	public static var defaultChunkCapacity = 64;

	public function new(army: ActorArmy, maxEntityCount: Int, batch: h2d.SpriteBatch) {
		final chunkCapacity = minInt(defaultChunkCapacity, maxEntityCount);
		final chunkCount = Math.ceil(maxEntityCount / chunkCapacity);
		final aosoa = ActorAosoa.create(army, chunkCapacity, chunkCount, batch);
		super(aosoa, batch);
	}
}
