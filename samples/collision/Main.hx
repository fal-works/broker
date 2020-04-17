package collision;

import broker.collision.CollisionDetector;
import broker.collision.Collider;
import banker.aosoa.ChunkEntityId;

class Main extends hxd.App {
	/**
		Set this to `true` for testing inter-group collision detection,
		or `false` for intra-group collision detection.
	**/
	static final interGroup: Bool = false;

	static final TWO_PI = 2 * Math.PI;

	var entities: EntityAosoa;
	var collisionDetector: CollisionDetector;
	var loadQuadtree: () -> Void;
	var onOverlap: (a: Collider, b: Collider) -> Void;

	override function init() {
		Constants.initialize(hxd.Window.getInstance());

		final tile = h2d.Tile.fromColor(0xFFFFFF, 24, 24).center();
		this.entities = createEntities(tile);

		final countPerEmit = 32;
		emitEntities(countPerEmit, 1);
		emitEntities(countPerEmit, 3);
		emitEntities(countPerEmit, 5);
		entities.synchronize();
		final leftGroupEntityCount = 3 * countPerEmit;

		final processCollider = (collider: Collider) -> {
			final id = ChunkEntityId.fromInt(collider.id);
			final chunk = entities.getChunk(id);
			final index = chunk.getReadIndex(id);
			final sprite = chunk.sprite[index];
			sprite.g = 0;
			sprite.b = 0.25;
		};

		if (interGroup) {
			this.onOverlap = (a: Collider, b: Collider) -> {
				processCollider(a);
			};
			this.collisionDetector = CollisionDetector.createInterGroup(
				Space.partitionLevel,
				leftGroupEntityCount,
				1
			);

			final rightCollider = new Collider(-1);
			final left = Constants.width / 2;
			final top = 0;
			final right = Constants.width - 1;
			final bottom = Constants.height / 2 - 1;
			rightCollider.setBounds(left, top, right, bottom);
			final cellIndex = Space.getCellIndex(left, top, right, bottom);
			this.collisionDetector.rightGroupCells.activate(cellIndex).add(rightCollider);
		} else {
			this.onOverlap = (a: Collider, b: Collider) -> {
				processCollider(a);
				processCollider(b);
			};
			this.collisionDetector = CollisionDetector.createIntraGroup(
				Space.partitionLevel,
				leftGroupEntityCount
			);
		}

		final leftCells = this.collisionDetector.leftGroupCells;
		this.loadQuadtree = () -> {
			leftCells.reset();
			entities.loadQuadTree(leftCells);
		}
	}

	override function update(dt: Float) {
		final entities = this.entities;
		entities.updatePosition();
		entities.bounce();
		entities.coolDown();
		// entities.resetColor();
		entities.synchronize();

		this.loadQuadtree();
		this.collisionDetector.detect(this.onOverlap);
	}

	function createEntities(tile: h2d.Tile): EntityAosoa
		return {
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
