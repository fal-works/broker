package broker.image.heaps;

import broker.image.internal.ImageData as InternalImageData;

@:notNull @:forward
abstract ImageData(InternalImageData) from InternalImageData to InternalImageData {
	@:from static function fromImage(image: hxd.res.Image): ImageData {
		final pixels = image.getPixels();
		final parsed = Tools.parseImageFileName(image.name);

		return {
			pixels: pixels,
			name: parsed.name,
			frameSize: parsed.frameSize,
			centerPivot: true
		};
	}
}
