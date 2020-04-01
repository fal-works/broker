package broker.entity.heaps;

#if heaps
/**
	Functions used when creating an AoSoA instance generated from
	any descendant class of `broker.entity.heaps.BasicEntity`.
**/
class BasicEntityInitializer {
	/**
		Factory function used in initialization of chunks.
	**/
	public static function spriteVectorFactory(
		chunkCapacity: Int
	): banker.vector.WritableVector<h2d.SpriteBatch.BatchElement> {
		return new banker.vector.WritableVector<h2d.SpriteBatch.BatchElement>(chunkCapacity);
	}
}
#end
