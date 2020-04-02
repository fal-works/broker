package broker.entity.heaps;

/**
	Interface that can be used for AoSoA classes generated from
	any descendant class of `broker.entity.heaps.BasicEntity`.

	Note that this is not automatically implemented.
**/
interface BasicAosoa extends broker.entity.BasicAosoa {
	/**
		Reflects position to sprite.
	**/
	function updateSprite(): Void;
}
