package broker.entity.heaps;

#if heaps
import broker.entity.heaps.BasicAosoa;

/**
	Wrapper of any AoSoA class.
**/
#if !broker_generic_disable
@:generic
#end
class EntityGroup<T: BasicAosoa> extends broker.entity.EntityGroup<T> {
	public final halfTileWidth: Float;
	public final halfTileHeight: Float;

	public function new(aosoa: T, batch: h2d.SpriteBatch) {
		super(aosoa);

		this.halfTileWidth = batch.tile.width / 2;
		this.halfTileHeight = batch.tile.height / 2;
	}

	override public function synchronize() {
		final aosoa = this.aosoa;
		aosoa.synchronize();
		aosoa.updateSprite(this.halfTileWidth, this.halfTileHeight);
	}
}
#end
