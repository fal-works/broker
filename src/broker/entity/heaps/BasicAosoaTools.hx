package broker.entity.heaps;

import banker.aosoa.interfaces.AosoaConstructible;

class BasicAosoaTools {
	/**
		Creates instance of any AoSoA class generated from
		any descendant class of `broker.entity.heaps.BasicEntity`.
	**/
	@:generic
	public static function create<T: AosoaConstructible>(
		chunkCapacity: Int,
		chunkCount: Int,
		batch: h2d.SpriteBatch
	): T {
		BasicEntityInitializer.batch = batch;

		final aosoa = new T(chunkCapacity, chunkCount);

		@:nullSafety(Off) BasicEntityInitializer.batch = cast null;

		return aosoa;
	}
}
