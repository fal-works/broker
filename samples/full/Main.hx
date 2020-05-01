package full;

class Main extends hxd.App {
	static function main()
		new Main();

	var world: World;

	override function init() {
		broker.input.heaps.HeapsKeyTools.initialize();
		broker.input.heaps.HeapsPadTools.initialize();

		world = new World(s2d);
	}

	override function update(dt: Float) {
		Global.gamepad.update();

		world.update();
	}
}
