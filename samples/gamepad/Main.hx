package gamepad;

import broker.App;
import broker.object.Object;
import broker.image.Tile;
import broker.draw.TileDraw;

class Main extends App {
	var gamepad: Gamepad;
	var object: Object;

	public function new() {
		super(800, 600, false);
	}

	override function initialize() {
		final gamepadPortIndex = 0;
		final dpadMoveSpeed = 10;
		gamepad = new Gamepad(gamepadPortIndex, dpadMoveSpeed);

		final tile = Tile.fromRgb(0xFFFFFF, 64, 64).toCentered();
		object = new TileDraw(tile);
		App.addRootObject(object);

		object.setPosition(App.width / 2, App.height / 2);
	}

	override function update() {
		gamepad.update();

		final stick = gamepad.stick;
		object.x += stick.x;
		object.y += stick.y;

		final scale = if (gamepad.buttons.A.isPressed) 2.0 else 1.0;
		object.setScale(scale);

		// Exit by ESC key
		if (hxd.Key.isDown(hxd.Key.ESCAPE)) hxd.System.exit();
	}
}
