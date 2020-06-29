package broker.image;

/**
	Pixels data.
**/
#if heaps
typedef Bitmap = broker.image.heaps.Bitmap;
#else
typedef Bitmap = Dynamic;
#end
