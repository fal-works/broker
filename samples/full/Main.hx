package full;

import broker.scene.SceneStack;
import full.scenes.PlayScene;

class Main extends hxd.App {
	static function main()
		new Main();

	static function profileGc() {
		final gcFlags = hl.Gc.flags;
		gcFlags.set(hl.Gc.GcFlag.Profile);
		hl.Gc.flags = gcFlags;
	}

	var sceneStack: SceneStack;

	override function init() {
		broker.input.heaps.HeapsKeyTools.initialize();
		broker.input.heaps.HeapsPadTools.initialize();
		broker.scene.heaps.Scene.setApplication(this);
		Global.initialize();

		final initialScene = new PlayScene(s2d);
		initialScene.fadeInFrom(ArgbColor.WHITE, 60, true);
		sceneStack = new SceneStack(initialScene, 16).newTag("scene stack");

		// profileGc();
	}

	override function update(dt: Float) {
		Global.update();
		sceneStack.update();
	}
}
