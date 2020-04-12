package collision;

import broker.collision.CollisionDetector;
import broker.collision.QuadtreeSpace;
import broker.collision.Collider;
import banker.aosoa.ChunkEntityId;

class Main extends hxd.App {
	static final TWO_PI = 2 * Math.PI;

	var entities: EntityAosoa;
	var collisionDetector: CollisionDetector<ChunkEntityId>;
	var loadQuadtree: (quadtree: QuadtreeSpace<ChunkEntityId>) -> Void;
	var onOverlap: (a: Collider<ChunkEntityId>, b: Collider<ChunkEntityId>) -> Void;

	override function init() {
		Constants.initialize(hxd.Window.getInstance());

		final tile = h2d.Tile.fromColor(0xFFFFFF, 24, 24).center();
		this.entities = createEntities(tile);

		final countPerEmit = 32;
		emitEntities(countPerEmit, 1);
		emitEntities(countPerEmit, 3);
		emitEntities(countPerEmit, 5);
		entities.synchronize();

		this.collisionDetector = new CollisionDetector(Constants.width, Constants.height, 4, ChunkEntityId.dummy);
		this.loadQuadtree = quadTree -> entities.loadQuadTree(quadTree);

		final processCollision = (id: ChunkEntityId) -> {
			final chunk = entities.getChunk(id);
			final index = chunk.getReadIndex(id);
			final sprite = chunk.sprite[index];
			sprite.g = 0;
			sprite.b = 0.25;
		};
		this.onOverlap = (a, b) -> {
			processCollision(a.value);
			processCollision(b.value);
		};
	}

	override function update(dt: Float) {
		final entities = this.entities;
		entities.updatePosition();
		entities.bounce();
		entities.coolDown();
		// entities.resetColor();
		entities.synchronize();

		this.collisionDetector.detect(this.loadQuadtree, this.onOverlap);
	}

	function createEntities(tile: h2d.Tile): EntityAosoa return {
		chunkCapacity: 128,
		chunkCount: 16,
		batchValue: new h2d.SpriteBatch(tile, s2d),
		spriteFactory: () -> new h2d.SpriteBatch.BatchElement(tile),
		halfTileWidthValue: tile.width / 2,
		halfTileHeightValue: tile.height / 2
	}

	function emitEntities(entityCount: Int, speed: Float): Void {
		final x = Constants.width / 2;
		final y = Constants.height / 2;
		final angleInterval = TWO_PI / entityCount;
		var direction = 0.0;

		while (direction < TWO_PI) {
			this.entities.emit(x, y, speed, direction);
			direction += angleInterval;
		}
	}
}
