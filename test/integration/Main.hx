package integration;

import integration.global.Gamepad;

class Main extends hxd.App {
	static function main() {
		new Main();
	}

	var army: ActorArmy;

	override function init() {
		hxd.Res.initEmbed();
		broker.heaps.HeapsKeyTools.initialize();

		ActorRenderer.initialize(s2d);
		army = new ActorArmy(s2d);

		debug("initialized.");
	}

	override function update(dt: Float) {
		Gamepad.update();

		army.update();

		final player = army.player;
		final bullets = army.bullets;

		player.x += Gamepad.stick.x;
		player.y += Gamepad.stick.y;

		if (Gamepad.buttons.A.isPressed) {
			bullets.use(player.x, player.y, 10, Math.random() * 2 * Math.PI);
		}

		army.synchronize();
	}
}
