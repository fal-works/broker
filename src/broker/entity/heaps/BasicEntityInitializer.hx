package broker.entity.heaps;

#if heaps
import sneaker.exception.Exception;

/**
	Values and functions used when creating an AoSoA instance
	from any descendant class of `broker.entity.heaps.BasicEntity`.
**/
class BasicEntityInitializer {
	/**
		`h2d.SpriteBatch` value used in initialization of chunks.
		Should be set before an AoSoA instance is created.
	**/
	@:nullSafety(Off)
	@:isVar
	public static var batch(get, set): h2d.SpriteBatch = null;

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

	static inline function get_batch() {
		if (batch == null) {
			final message = "Cannot create AoSoA instance. Required to be set: broker.entity.heaps.BasicEntityInitializer.batch";
			throw new Exception(message);
		}
		return batch;
	}

	static inline function set_batch(newBatch) return batch = newBatch;
}
#end
