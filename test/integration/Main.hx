package integration;

import integration.global.Gamepad;

class Main extends hxd.App {
	static function main() {
		new Main();
	}

	var army: ActorArmy;

	override function init() {
		hxd.Res.initEmbed();
		broker.input.heaps.HeapsKeyTools.initialize();

		final playerTile = hxd.Res.player.toTile().center();
		final playerBatch = new h2d.SpriteBatch(playerTile, s2d);

		final playerBulletTile = hxd.Res.player_bullet.toTile().center();
		final playerBulletBatch = new h2d.SpriteBatch(
			playerBulletTile,
			s2d
		);

		army = new ActorArmy(1, playerBatch, 1024, playerBulletBatch);
		army.agents.use(200, 200, 0, 0);

		debug("initialized.");
	}

	override function update(dt: Float) {
		Gamepad.update();

		army.update();
		army.synchronize();
	}
}
