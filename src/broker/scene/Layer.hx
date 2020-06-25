package broker.scene;

/**
	Drawing layer.
**/
#if heaps
typedef Layer = broker.scene.heaps.Layer;
#else
typedef Layer = Dynamic;
#end
