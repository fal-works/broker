package broker.scene;

/**
	Game scene.
**/
#if heaps
typedef Scene = broker.scene.heaps.Scene;
#else
typedef Scene = broker.scene.common.Scene;
#end
