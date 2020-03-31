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

		final playerBatch = new h2d.SpriteBatch(hxd.Res.player.toTile(), s2d);
		final playerBulletBatch = new h2d.SpriteBatch(
			hxd.Res.player_bullet.toTile(),
			s2d
		);

		army = new ActorArmy(1, playerBatch, 1024, playerBulletBatch);
		army.agents.aosoa.emit(200, 200, 0, 0);

		debug("initialized.");
	}

	override function update(dt: Float) {
		Gamepad.update();

		army.update();
		army.synchronize();
	}
}
