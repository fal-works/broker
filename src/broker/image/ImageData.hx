package broker.image;

/**
	Image data including bitmap and some additional information.
**/
#if heaps
typedef ImageData = broker.image.heaps.ImageData;
#else
typedef ImageData = broker.image.common.ImageData;
#end
