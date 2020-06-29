package broker.image.heaps;

import broker.image.common.Atlas as AtlasBase;

class Atlas extends AtlasBase {
	/**
		Creates an `Atlas` instance from `imageDataList`.
		@param imageDataList Enum, either `Vertical`, `Horizontal` or `Unit`.
	**/
	public static function from(imageDataList: ImageDataList): Atlas {
		final entireSize = imageDataList.getBoundSize();
		final entirePixels = hxd.Pixels.alloc(
			entireSize.width,
			entireSize.height,
			BGRA
		);
		final frameTilesBuilderMap = new Map<String, (
			texture: h3d.mat.Texture
		) -> FrameTiles>();

		processImageDataList(
			imageDataList,
			UInt.zero,
			UInt.zero,
			entirePixels,
			frameTilesBuilderMap
		);

		final texture = h3d.mat.Texture.fromPixels(entirePixels);
		final frameTilesMap = new Map<String, FrameTiles>();
		for (name => build in frameTilesBuilderMap)
			frameTilesMap.set(name, build(texture));

		return new Atlas(frameTilesMap, texture);
	}

	private static function processImageDataList(
		imageDataList: ImageDataList,
		destX: UInt,
		destY: UInt,
		entirePixels: Bitmap,
		frameTilesBuilderMap: Map<String, (texture: h3d.mat.Texture) -> FrameTiles>
	): { width: UInt, height: UInt} {
		switch imageDataList {
			case Vertical(elements):
				var width = UInt.zero;
				var height = UInt.zero;
				for (element in elements) {
					final size = processImageDataList(
						element,
						destX,
						destY,
						entirePixels,
						frameTilesBuilderMap
					);
					if (width < size.width) width = size.width;
					height += size.height;
					destY += size.height;
				}
				return { width: width, height: height };
			case Horizontal(elements):
				var width = UInt.zero;
				var height = UInt.zero;
				for (element in elements) {
					final size = processImageDataList(
						element,
						destX,
						destY,
						entirePixels,
						frameTilesBuilderMap
					);
					width += size.width;
					if (height < size.height) height = size.height;
					destX += size.width;
				}
				return { width: width, height: height };
			case Unit(data):
				final srcPixels = data.pixels;
				final width = srcPixels.width;
				final height = srcPixels.height;
				Bitmap.blit(srcPixels, 0, 0, entirePixels, destX, destY, width, height);
				srcPixels.dispose();
				frameTilesBuilderMap.set(
					data.name,
					(texture) -> broker.image.heaps.FrameTiles.fromData(
						texture,
						destX,
						destY,
						width,
						height,
						data.frameSize,
						data.centerPivot
					)
				);
				return { width: width, height: height };
		}
	}

	public final texture: h3d.mat.Texture;

	public function new(frameTilesMap: Map<String, FrameTiles>, texture: h3d.mat.Texture) {
		super(frameTilesMap);
		this.texture = texture;
	}
}
