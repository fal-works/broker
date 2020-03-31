package broker.entity;

/**
	Interface that can be used for AoSoA classes generated from
	any descendant class of `broker.entity.BasicEntity`.

	Note that this is not automatically implemented.
**/
interface BasicAosoa extends banker.aosoa.interfaces.Aosoa {
	/**
		Uses a new available entity and sets initial position/velocity.
	**/
	function emit(
		initialX: Float,
		initialY: Float,
		speed: Float,
		direction: Float
	): Void;

	/**
		Updates position by adding current velocity.
	**/
	function updatePosition(): Void;
}
