package integration;

/**
	Values and functions used when creating an AoSoA of `Entity`.
**/
class BasicEntityInitializer {
	/**
		`h2d.SpriteBatch` value used in initialization of chunks.
		Should be set before an AoSoA is created.
	**/
	public static var batch: h2d.SpriteBatch;

	/**
		Factory function used in initialization of chunks.
	**/
	public static function spriteVectorFactory(chunkCapacity: Int): banker.vector.WritableVector<Sprite> {
		return new banker.vector.WritableVector<Sprite>(chunkCapacity);
	}

	/**
		Factory function used in initialization of entities.
	**/
	public static function spriteFactory(): Sprite {
		return new Sprite(batch.tile);
	}
}
