package collision;

import broker.image.Tile;
import broker.App;
import broker.draw.BatchDraw;
import banker.aosoa.ChunkEntityId;
import broker.collision.CollisionDetector;
import broker.collision.Collider;
import broker.draw.BatchSprite;

class Settings {
	/**
		Set this to `true` for testing inter-group collision detection,
		or `false` for intra-group collision detection.
	**/
	public static inline final interGroup: Bool = false;

	public static inline final tileSize: UInt = 24;

	public static inline final entityCountPerEmit: UInt = 24;

	public static inline final speedFactor: Float = 1.0;
}

class Main extends broker.App {
	var entities: EntityAosoa;
	var collisionDetector: CollisionDetector;
	var loadQuadtree: () -> Void;
	var onOverlap: (a: Collider, b: Collider) -> Void;

	public function new() {
		super(800, 600, false);
	}

	function initializeIntraGroupCollision(
		processColliderOnOverlap: Collider->Void,
		leftGroupEntityCount: Int
	) {
		this.onOverlap = (a: Collider, b: Collider) -> {
			processColliderOnOverlap(a);
			processColliderOnOverlap(b);
		};

		this.collisionDetector = CollisionDetector.createIntraGroup(
			Space.partitionLevel,
			leftGroupEntityCount
		);
	}

	function initializeInterGroupCollision(
		processColliderOnOverlap: Collider->Void,
		leftGroupEntityCount: Int
	) {
		this.onOverlap = (a: Collider, b: Collider) -> {
			processColliderOnOverlap(a);
			// Ignore b
		};

		this.collisionDetector = CollisionDetector.createInterGroup(
			Space.partitionLevel,
			{
				left: { maxColliderCount: leftGroupEntityCount },
				right: { maxColliderCount: 1 }
			}
		);

		// Just one static invisible collider in the "right" group
		final rightCollider = new Collider(-1);
		final left = Constants.width / 2;
		final top = 0.0;
		final right = Constants.width - 1;
		final bottom = Constants.height / 2 - 1;
		rightCollider.setBounds(left, top, right, bottom);
		final cellIndex = Space.getCellIndex(left, top, right, bottom);
		this.collisionDetector.rightQuadtree.loadAt(cellIndex, rightCollider);
	}

	override function initialize() {
		Constants.initialize();

		final leftGroupEntityCount = 3 * Settings.entityCountPerEmit;

		final tile = Tile.fromRgb(
			0xFFFFFF,
			Settings.tileSize,
			Settings.tileSize
		).toCentered();
		this.entities = createEntities(tile, leftGroupEntityCount);

		emitEntities(1);
		emitEntities(3);
		emitEntities(5);
		entities.synchronize();

		final processColliderOnOverlap = (collider: Collider) -> {
			final id = ChunkEntityId.fromInt(collider.id);
			final chunk = entities.getChunk(id);
			final index = chunk.getReadIndex(id);
			final sprite = chunk.sprite[index];
			sprite.data.g = 0;
			sprite.data.b = 0.25;
		};

		if (Settings.interGroup)
			initializeInterGroupCollision(
				processColliderOnOverlap,
				leftGroupEntityCount
			);
		else
			initializeIntraGroupCollision(
				processColliderOnOverlap,
				leftGroupEntityCount
			);

		final leftQuadtree = this.collisionDetector.leftQuadtree;
		this.loadQuadtree = () -> {
			leftQuadtree.reset();
			entities.loadQuadTree(leftQuadtree);
		}
	}

	override function update() {
		final entities = this.entities;
		entities.updatePosition();
		entities.bounce();
		entities.coolDown();
		// entities.resetColor();
		entities.synchronize();

		this.loadQuadtree();
		this.collisionDetector.detect(this.onOverlap);
	}

	function createEntities(tile: Tile, capacity: UInt): EntityAosoa {
		final batch = new BatchDraw(tile.getTexture(), App.width, App.height, false);
		App.addRootObject(batch);

		return {
			chunkCapacity: 128,
			chunkCount: Math.ceil(capacity / 128),
			batchValue: batch,
			spriteFactory: () -> new BatchSprite(tile),
			halfTileWidthValue: tile.width / 2,
			halfTileHeightValue: tile.height / 2
		}
	}

	function emitEntities(speed: Float): Void {
		final x = Constants.width / 2;
		final y = Constants.height / 2;
		final speed = Settings.speedFactor * speed;
		final angleInterval = 2 * Math.PI / Settings.entityCountPerEmit;

		var direction = 0.0;
		for (i in 0...Settings.entityCountPerEmit) {
			this.entities.emit(x, y, speed, direction);
			direction += angleInterval;
		}
	}
}
