package collision;

import banker.vector.WritableVector as Vec;
import banker.aosoa.ChunkEntityId;
import broker.entity.BasicBatchEntity;
import broker.draw.BatchSprite;
import broker.collision.*;

class Entity extends BasicBatchEntity {
	@:nullSafety(Off)
	@:banker_chunkLevelFinal
	var halfTileWidth: Float;

	@:nullSafety(Off)
	@:banker_chunkLevelFinal
	var halfTileHeight: Float;

	@:banker_factoryWithId((id: ChunkEntityId) -> new Collider(id.int()))
	@:banker_swap
	var collider: Collider;

	static function bounce(
		x: Vec<Float>,
		y: Vec<Float>,
		vx: Vec<Float>,
		vy: Vec<Float>,
		i: Int
	): Void {
		if (x[i] < 0) {
			x[i] = 0;
			vx[i] *= -1;
		} else if (x[i] > Constants.width) {
			x[i] = Constants.width;
			vx[i] *= -1;
		}

		if (y[i] < 0) {
			y[i] = 0;
			vy[i] *= -1;
		} else if (y[i] > Constants.height) {
			y[i] = Constants.height;
			vy[i] *= -1;
		}
	}

	static function resetColor(sprite: BatchSprite): Void {
		final spr = sprite.data;
		spr.r = 1.0;
		spr.g = 1.0;
		spr.b = 1.0;
	}

	static function coolDown(sprite: BatchSprite): Void {
		final spr = sprite.data;
		spr.r += 0.2 * (1.0 - spr.r);
		spr.g += 0.2 * (1.0 - spr.g);
		spr.b += 0.2 * (1.0 - spr.b);
	}

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
		quadtree: Quadtree
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

@:build(banker.aosoa.Chunk.fromStructure(collision.Entity))
class EntityChunk {}
