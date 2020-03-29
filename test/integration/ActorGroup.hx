package integration;

import banker.common.MathTools.minInt;

class ActorGroup {
	public static var defaultChunkCapacity = 64;

	public static function create(army: ActorArmy, maxEntityCount: Int, batch: h2d.SpriteBatch): ActorGroup {
		ActorGroup.army = army;

		final chunkCapacity = minInt(defaultChunkCapacity, maxEntityCount);
		ActorGroup.chunkCapacity = chunkCapacity;
		ActorGroup.chunkCount = Math.ceil(maxEntityCount / chunkCapacity);

		ActorGroup.batch = batch;

		final group = new ActorGroup();

		@:nullSafety(Off) ActorGroup.army = cast null;
		@:nullSafety(Off) ActorGroup.batch = cast null;

		return group;
	}

	static var army: ActorArmy;
	static var chunkCapacity = 0;
	static var chunkCount = 0;
	static var batch: h2d.SpriteBatch;

	public final aosoa = Actor.ActorTools.createAosoa(army, chunkCapacity, chunkCount, batch);

	public function synchronize() {
		final aosoa = this.aosoa;
		aosoa.synchronize();
		aosoa.updateSprite();
	}

	private function new() {}
}
