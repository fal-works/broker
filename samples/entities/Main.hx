package entities;

import broker.App;
import broker.image.Tile;
import broker.draw.BatchDraw;
import broker.draw.BatchSprite;

class Main extends broker.App {
	var entities: EntityAosoa;
	var frameCount = 0;

	public function new() {
		super(800, 600, false);
	}

	override function initialize() {
		final tile = Tile.fromRgb(0xFFFFFF, 16, 16).toCentered();
		entities = createEntities(tile);
	}

	override function update() {
		emitEntity();

		entities.updatePosition();
		entities.killOutOfWindow();
		entities.synchronize();

		++frameCount;
	}

	function createEntities(tile: Tile) {
		final chunkCapacity = 128;
		final chunkCount = 16;
		final spriteFactory = () -> new BatchSprite(tile);
		final batch = new BatchDraw(tile.getTexture(), App.width, App.height);
		App.addRootObject(batch);

		return new EntityAosoa(chunkCapacity, chunkCount, batch, spriteFactory);
	}

	function emitEntity() {
		final radius = 150;
		final angle = 0.05 * frameCount;

		final x = App.width / 2 + radius * Math.cos(angle);
		final y = App.height / 2 + radius * Math.sin(angle);
		final speed = 5;
		final direction = -1.5 * angle;

		entities.emit(x, y, speed, direction);
	}
}
