package gamepad;

import broker.input.heaps.HeapsKeyTools;
import broker.input.heaps.HeapsPadTools;

class Main extends hxd.App {
	var gamepad: Gamepad;
	var object: h2d.Object;

	override function init() {
		HeapsKeyTools.initialize();
		HeapsPadTools.initialize();

		final gamepadPortIndex = 0;
		final dpadMoveSpeed = 10;
		gamepad = new Gamepad(gamepadPortIndex, dpadMoveSpeed);

		final tile = h2d.Tile.fromColor(0xFFFFFF, 64, 64).center();
		object = new h2d.Bitmap(tile, s2d);

		final window = hxd.Window.getInstance();
		object.setPosition(window.width / 2, window.height / 2);
	}

	override function update(dt: Float) {
		gamepad.update();

		final stick = gamepad.stick;
		object.x += stick.x;
		object.y += stick.y;

		final buttonA = gamepad.buttons.A;
		final scale = if (buttonA.isPressed) 2.0 else 1.0;
		object.setScale(scale);

		// Exit by ESC key
		if (hxd.Key.isDown(hxd.Key.ESCAPE)) hxd.System.exit();
	}
}
