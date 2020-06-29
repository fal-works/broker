package broker.image;

/**
	A recursive list of `ImageData` for arranging the layout of images in `Atlas`.
**/
@:using(broker.image.ImageDataList.ImageDataListExtension)
enum ImageDataList {
	Vertical(elements: Array<ImageDataList>);
	Horizontal(elements: Array<ImageDataList>);
	Unit(data: ImageData);
}

class ImageDataListExtension {
	public static function getBoundSize(list: ImageDataList): PixelSize {
		switch list {
			case Vertical(elements):
				var width = UInt.zero;
				var height = UInt.zero;
				for (element in elements) {
					final size = getBoundSize(element);
					if (width < size.width) width = size.width;
					height += size.height;
				}
				return { width: width, height: height };
			case Horizontal(elements):
				var width = UInt.zero;
				var height = UInt.zero;
				for (element in elements) {
					final size = getBoundSize(element);
					width += size.width;
					if (height < size.height) height = size.height;
				}
				return { width: width, height: height };
			case Unit(data):
				final bitmap = data.bitmap;
				return { width: bitmap.width, height: bitmap.height };
		}
	}
}
