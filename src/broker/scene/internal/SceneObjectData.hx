package broker.scene.internal;

/**
	Alias for the underlying type of `SceneObject`.
**/
#if heaps
typedef SceneObjectData = h2d.Object;
#else
typedef SceneObjectData = Dynamic;
#end
