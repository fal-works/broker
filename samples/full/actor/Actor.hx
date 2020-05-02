package full.actor;

import broker.entity.heaps.BasicEntity;

@:banker_verified
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

	/**
		Clojure function for emitting a new bullet.
	**/
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

	/**
		Set `found` to `true` if any entity overlaps `otherAabb`.
		@param otherAabb
		@param found
	**/
	static function findOverlapped(
		x: Float,
		y: Float,
		halfTileWidth: Float,
		halfTileHeight: Float,
		otherAabb: Aabb,
		found: Reference<Bool>
	): Void {
		if (otherAabb.overlapsAabb(
			x - halfTileWidth,
			y - halfTileHeight,
			x + halfTileWidth,
			y + halfTileHeight
		)) {
			found.set(true);
		}
	}

	/**
		Disuses all entities currently in use and emits particles.
	**/
	static function crashAll(
		x: Float,
		y: Float,
		sprite: h2d.SpriteBatch.BatchElement,
		i: Int,
		disuse: Bool,
		disusedSprites: banker.vector.WritableVector<h2d.SpriteBatch.BatchElement>,
		disusedCount: Int
	): Void {
		disuse = true;
		disusedSprites[disusedCount] = sprite;
		++disusedCount;
		Global.emitParticles(x, y, 1, 6, 6);
	}
}
