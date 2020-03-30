package broker.entity;

import broker.entity.BasicAosoa;

/**
	Wrapper of any AoSoA class.
**/
#if !broker_generic_disable
@:generic
#end
class EntityGroup<T: BasicAosoa> {
	public final aosoa: T;

	public function new(aosoa: T)
		this.aosoa = aosoa;

	public function synchronize(): Void
		this.aosoa.synchronize();

	public function updatePosition(): Void
		this.aosoa.updatePosition();

	public inline function emit(
		initialX: Float,
		initialY: Float,
		speed: Float,
		direction: Float
	): Void {
		this.aosoa.emit(initialX, initialY, speed, direction);
	}
}
