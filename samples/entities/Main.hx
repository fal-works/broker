package entities;

class Main extends hxd.App {
	var entities: EntityAosoa;
	var frameCount = 0;

	override function init() {
		broker.App.initialize(800, 600);

		final tile = h2d.Tile.fromColor(0xFFFFFF, 16, 16).center();
		entities = createEntities(tile);
	}

	override function update(dt: Float) {
		emitEntity();

		entities.updatePosition();
		entities.killOutOfWindow();
		entities.synchronize();

		++frameCount;
	}

	function createEntities(tile: h2d.Tile) {
		final chunkCapacity = 128;
		final chunkCount = 16;
		final spriteFactory = () -> new h2d.SpriteBatch.BatchElement(tile);
		final batch = new h2d.SpriteBatch(tile, s2d);

		return new EntityAosoa(chunkCapacity, chunkCount, batch, spriteFactory);
	}

	function emitEntity() {
		final radius = 150;
		final angle = 0.05 * frameCount;

		final x = broker.App.width / 2 + radius * Math.cos(angle);
		final y = broker.App.height / 2 + radius * Math.sin(angle);
		final speed = 5;
		final direction = -1.5 * angle;

		entities.emit(x, y, speed, direction);
	}
}
