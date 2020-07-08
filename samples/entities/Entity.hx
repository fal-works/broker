package entities;

import broker.App;
import broker.entity.BasicBatchEntity;
import banker.vector.WritableVector as Vec;
import h2d.SpriteBatch.BatchElement;

class Entity extends BasicBatchEntity {
	static function killOutOfWindow(
		sprite: BatchElement,
		x: Float,
		y: Float,
		i: Int,
		disuse: Bool,
		disusedSprites: Vec<BatchElement>,
		disusedCount: Int
	): Void {
		if (x < 0 || x > App.width.int() || y < 0 || y > App.height.int()) {
			disuse = true;
			disusedSprites[disusedCount] = sprite;
			++disusedCount;
		}
	}
}

@:build(banker.aosoa.Chunk.fromStructure(entities.Entity))
class EntityChunk {}
