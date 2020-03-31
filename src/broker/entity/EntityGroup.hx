package broker.entity;

import broker.entity.BasicAosoa;

/**
	Wrapper of any AoSoA class.
**/
#if !broker_generic_disable
@:generic
#end
class EntityGroup<T:BasicAosoa> {
	public final aosoa: T;

	public function new(aosoa: T)
		this.aosoa = aosoa;

	/**
		Reflects changes after the last synchronization.
	**/
	public function synchronize(): Void
		this.aosoa.synchronize();

	/**
		Uses a new available entity and sets initial position/velocity.
	**/
	public inline function emit(
		initialX: Float,
		initialY: Float,
		speed: Float,
		direction: Float
	): Void {
		this.aosoa.emit(initialX, initialY, speed, direction);
	}

	/**
		Updates position of all entities in use.
	**/
	public function updatePosition(): Void
		this.aosoa.updatePosition();
}
