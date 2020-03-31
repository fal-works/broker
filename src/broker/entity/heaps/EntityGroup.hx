package broker.entity.heaps;

#if heaps
import broker.entity.heaps.BasicAosoa;

/**
	Wrapper for any descendant class of `broker.entity.heaps.BasicAosoa`.
**/
	#if !broker_generic_disable
	@:generic
	#end
class EntityGroup<T:BasicAosoa> extends broker.entity.EntityGroup<T> {
	public final halfTileWidth: Float;
	public final halfTileHeight: Float;

	public function new(aosoa: T, tile: h2d.Tile) {
		super(aosoa);

		this.halfTileWidth = tile.width / 2;
		this.halfTileHeight = tile.height / 2;
	}

	/**
		Reflects changes after the last synchronization.
	**/
	override public function synchronize() {
		final aosoa = this.aosoa;
		aosoa.synchronize();
		aosoa.updateSprite(this.halfTileWidth, this.halfTileHeight);
	}
}
#end
