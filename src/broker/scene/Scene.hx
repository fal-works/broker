package broker.scene;

import broker.scene.common.Scene as IScene;

/**
	Game scene.
**/
@:forward
abstract Scene(IScene) from IScene to IScene {}
