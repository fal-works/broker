package integration;

import banker.common.MathTools.minInt;

class ActorGroup {
	public static var defaultChunkCapacity = 64;

	public final aosoa: ActorAosoa;

	public function new(army: ActorArmy, maxEntityCount: Int, batch: h2d.SpriteBatch) {
		final chunkCapacity = minInt(defaultChunkCapacity, maxEntityCount);
		final chunkCount = Math.ceil(maxEntityCount / chunkCapacity);

		this.aosoa = Actor.ActorTools.createAosoa(army, chunkCapacity, chunkCount, batch);
	}

	public function synchronize() {
		final aosoa = this.aosoa;
		aosoa.synchronize();
		aosoa.updateSprite();
	}
}
