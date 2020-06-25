package broker.scene;

#if heaps
typedef SceneObject = broker.scene.heaps.SceneObject;
#else
typedef SceneObject = Dynamic;
#end
