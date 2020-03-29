package integration;

import banker.common.MathTools.minInt;

/**
	Wrapper of `ActorAosoa`.
**/
class ActorGroup {
	public static var defaultChunkCapacity = 64;

	public final aosoa: ActorAosoa;
	public final halfTileWidth: Float;
	public final halfTileHeight: Float;

	public function new(army: ActorArmy, maxEntityCount: Int, batch: h2d.SpriteBatch) {
		final chunkCapacity = minInt(defaultChunkCapacity, maxEntityCount);
		final chunkCount = Math.ceil(maxEntityCount / chunkCapacity);
		this.aosoa = ActorAosoa.create(army, chunkCapacity, chunkCount, batch);

		this.halfTileWidth = batch.tile.width / 2;
		this.halfTileHeight = batch.tile.height / 2;
	}

	public function synchronize() {
		final aosoa = this.aosoa;
		aosoa.synchronize();
		aosoa.updateSprite(this.halfTileWidth, this.halfTileHeight);
	}
}
