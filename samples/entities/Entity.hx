package entities;

import broker.entity.heaps.BasicEntity;
import banker.vector.WritableVector as Vec;
import h2d.SpriteBatch.BatchElement;

class Entity extends BasicEntity {
	static function killOutOfWindow(
		sprite: BatchElement,
		x: Float,
		y: Float,
		i: Int,
		disuse: Bool,
		disusedSprites: Vec<BatchElement>,
		disusedCount: Int
	): Void {
		if (x < 0 || x > Constants.width || y < 0 || y > Constants.height) {
			disuse = true;
			disusedSprites[disusedCount] = sprite;
			++disusedCount;
		}
	}
}

@:build(banker.aosoa.Chunk.fromStructure(entities.Entity))
class EntityChunk {}
