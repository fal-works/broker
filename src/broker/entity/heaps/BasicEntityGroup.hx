package broker.entity.heaps;

#if heaps
import broker.entity.heaps.BasicAosoa;

/**
	Wrapper for any descendant class of `broker.entity.heaps.BasicAosoa`.
**/
	#if !broker_generic_disable
	@:generic
	#end
class BasicEntityGroup<T:BasicAosoa> extends broker.entity.BasicEntityGroup<T> {
	public function new(aosoa: T, tile: h2d.Tile) {
		super(aosoa);
	}

	/**
		Reflects changes after the last synchronization.
	**/
	override public function synchronize() {
		final aosoa = this.aosoa;
		aosoa.synchronize();
		aosoa.updateSprite();
	}
}
#end
