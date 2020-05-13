package full.scenes;

import broker.scene.SceneTypeId;

enum abstract SceneType(SceneTypeId) to SceneTypeId {
	final play = SceneTypeId.from(0);
}
