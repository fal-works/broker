package broker.scene;

#if heaps
typedef Layer = broker.scene.heaps.Layer;
#else
typedef Layer = Dynamic;
#end
