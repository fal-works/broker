package integration;

import integration.global.Gamepad;

class Main extends hxd.App {
	static function main() {
		new Main();
	}

	var player: h2d.Object;

	override function init() {
		hxd.Res.initEmbed();
		broker.heaps.HeapsKeyTools.initialize();

		player = new h2d.Bitmap(hxd.Res.player.toTile(), s2d);
		player.x = 100;
		player.y = 100;

		debug("initialized.");
	}

	override function update(dt: Float) {
		Gamepad.update();
		if (Gamepad.buttons.A.isJustPressed) debug("Pressed A");
		player.x += Gamepad.stick.x;
		player.y += Gamepad.stick.y;
	}
}
