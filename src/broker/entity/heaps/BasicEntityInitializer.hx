package broker.entity.heaps;

#if heaps
/**
	Values and functions used when creating an AoSoA of `Entity`.
**/
class BasicEntityInitializer {
	/**
		`h2d.SpriteBatch` value used in initialization of chunks.
		Should be set before an AoSoA is created.
	**/
	@:nullSafety(Off)
	public static var batch: h2d.SpriteBatch;

	/**
		Factory function used in initialization of chunks.
	**/
	public static function spriteVectorFactory(chunkCapacity: Int): banker.vector.WritableVector<h2d.SpriteBatch.BatchElement> {
		return new banker.vector.WritableVector<h2d.SpriteBatch.BatchElement>(chunkCapacity);
	}

	/**
		Factory function used in initialization of entities.
	**/
	public static function spriteFactory(): h2d.SpriteBatch.BatchElement {
		return new h2d.SpriteBatch.BatchElement(batch.tile);
	}
}
#end
