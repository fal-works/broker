package broker.entity;

interface BasicAosoa extends banker.aosoa.interfaces.Aosoa {
	function emit(
		initialX: Float,
		initialY: Float,
		speed: Float,
		direction: Float
	): Void;

	function updatePosition(): Void;
}
