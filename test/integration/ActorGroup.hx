package integration;

import banker.common.MathTools.minInt;
import broker.entity.heaps.EntityGroup;

/**
	Wrapper of `ActorAosoa`.
**/
class ActorGroup extends EntityGroup<ActorAosoa> {
	public static var defaultChunkCapacity = 64;

	public function new(
		aosoaConstructor: (chunkCapacity: Int, chunkCount: Int) -> ActorAosoa,
		maxEntityCount: Int,
		batch: h2d.SpriteBatch,
		fireCallback: FireCallback
	) {
		final chunkCapacity = minInt(defaultChunkCapacity, maxEntityCount);
		final chunkCount = Math.ceil(maxEntityCount / chunkCapacity);

		final aosoa = ActorAosoaBuilder.create(
			aosoaConstructor.bind(chunkCapacity, chunkCount),
			batch,
			fireCallback
		);

		super(aosoa, batch.tile);
	}
}
