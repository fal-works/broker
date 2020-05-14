package full.scenes;

import broker.scene.SceneTypeId;
import broker.scene.heaps.Scene;
import full.World;

class PlayScene extends Scene {
	final world: World;

	public function new(?heapsScene: h2d.Scene) {
		super(if (heapsScene != null) heapsScene else new h2d.Scene());
		this.world = new World(this.mainLayer.heapsObject);
	}

	override public inline function getTypeId(): SceneTypeId
		return SceneType.play;

	override function update(): Void {
		super.update();
		world.update();

		if (Global.gamepad.buttons.Y.isPressed)
			this.goToNextScene();
	}

	override function activate(): Void {
		super.activate();
		Global.resetParticles(this.heapsScene);
	}

	function goToNextScene(): Void {
		final nextScene = new PlayScene();
		this.fadeOutTo(0xFF000000, 30);
		this.switchTo(nextScene, 60, true);
		nextScene.fadeInFrom(0xFF000000, 30);
	}
}
