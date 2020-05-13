package full.scenes;

import broker.scene.SceneTypeId;
import broker.scene.heaps.Scene;
import full.World;

class PlayScene extends Scene {
	final world: World;

	public function new(heapsScene: h2d.Scene) {
		super(heapsScene);
		this.world = new World(this.mainLayer);
	}

	override public inline function getTypeId(): SceneTypeId
		return SceneType.play;

	override function update(): Void {
		super.update();
		world.update();
	}
}
