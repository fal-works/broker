package full.actor;

import broker.entity.heaps.BasicEntity;

class Actor extends BasicEntity {
	@:nullSafety(Off)
	@:banker_chunkLevelFinal
	var halfTileWidth: Float;

	@:nullSafety(Off)
	@:banker_chunkLevelFinal
	var halfTileHeight: Float;

	@:banker_factoryWithId((id: ChunkEntityId) -> new Collider(id.int()))
	@:banker_swap
	var collider: Collider;

	@:banker_chunkLevelFinal
	var fire: FireCallback;

	/**
		Registers entities to `quadtree`.
		@param quadtree
	**/
	static function loadQuadTree(
		id: ChunkEntityId,
		x: Float,
		y: Float,
		collider: Collider,
		halfTileWidth: Float,
		halfTileHeight: Float,
		quadtree: Quadtree,
		i: UInt
	): Void {
		final left = x - halfTileWidth;
		final top = y - halfTileHeight;
		final right = x + halfTileWidth;
		final bottom = y + halfTileHeight;

		final cellIndex = Space.getCellIndex(left, top, right, bottom);
		if (cellIndex.isSome()) {
			collider.setBounds(left, top, right, bottom);
			quadtree.loadAt(cellIndex, collider);
		}
	}
}
