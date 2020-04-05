package integration;

class Main extends hxd.App {
	static function main() {
		new Main();
	}

	var army: ActorArmy;

	override function init() {
		hxd.Res.initEmbed();
		broker.input.heaps.HeapsKeyTools.initialize();
		broker.input.heaps.HeapsPadTools.initialize();

		final playerTile = h2d.Tile.fromColor(0xFFFFFF, 64, 64).center();
		final playerBatch = new h2d.SpriteBatch(playerTile, s2d);

		final playerBulletTile = h2d.Tile.fromColor(0xFFFFFF, 32, 32).center();
		final playerBulletBatch = new h2d.SpriteBatch(
			playerBulletTile,
			s2d
		);

		army = new ActorArmy(1, playerBatch, 1024, playerBulletBatch);
		army.agents.use(200, 200, 0, 0);

		debug("initialized.");
	}

	override function update(dt: Float) {
		Global.gamepad.update();

		army.update();
		army.synchronize();
	}
}
