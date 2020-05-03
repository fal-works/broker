package full;

import broker.scene.SceneStack;
import full.scenes.PlayScene;

class Main extends hxd.App {
	static function main()
		new Main();

	var sceneStack: SceneStack;

	override function init() {
		broker.input.heaps.HeapsKeyTools.initialize();
		broker.input.heaps.HeapsPadTools.initialize();
		broker.scene.heaps.Scene.initialize(this);
		Global.initialize(s2d);

		final initialScene = new PlayScene(s2d);
		sceneStack = new SceneStack(initialScene, 16).newTag("scene stack");
	}

	override function update(dt: Float) {
		Global.update();
		sceneStack.update();
	}
}
