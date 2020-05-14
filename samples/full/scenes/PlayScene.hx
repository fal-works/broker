package full.scenes;

import broker.scene.SceneTypeId;
import broker.scene.heaps.Scene;
import full.World;

class PlayScene extends Scene {
	var world: World;

	public function new(?heapsScene: h2d.Scene) {
		super(if (heapsScene != null) heapsScene else new h2d.Scene());

		@:nullSafety(Off) this.world = null;
	}

	override public inline function getTypeId(): SceneTypeId
		return SceneType.play;

	override function initialize(): Void {
		super.initialize();
		this.world = new World(this.mainLayer.heapsObject);
	}

	override function update(): Void {
		super.update();
		this.world.update();

		if (Global.gamepad.buttons.Y.isPressed)
			this.goToNextScene();
	}

	override function activate(): Void {
		super.activate();
		Global.resetParticles(this.heapsScene);
	}

	function goToNextScene(): Void {
		final nextScene = new PlayScene();
		Global.sceneTransitionTable.runTransition(this, nextScene);
	}
}
