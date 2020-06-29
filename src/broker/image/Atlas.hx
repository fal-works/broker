package broker.image;

/**
	Graphics data combined in one texture.
**/
#if heaps
typedef Atlas = broker.image.heaps.Atlas;
#else
typedef Atlas = Dynamic;
#end
