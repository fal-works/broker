package broker.image;

import haxe.ds.StringMap;

/**
	Graphics data combined in one texture.
**/
class Atlas {
	/**
		Creates an `Atlas` instance from `imageDataList`.
		@param imageDataList Enum, either `Vertical`, `Horizontal` or `Unit`.
	**/
	public static function from(imageDataList: ImageDataList): Atlas {
		final entireSize = imageDataList.getBoundSize();
		final entirePixels = new Pixels(entireSize.width, entireSize.height);
		final frameTilesBuilderMap = new StringMap<(texture: Texture) -> FrameTiles>();

		processImageDataList(
			imageDataList,
			UInt.zero,
			UInt.zero,
			entirePixels,
			frameTilesBuilderMap
		);

		final texture = Texture.fromPixels(entirePixels);
		final frameTilesMap = new StringMap<FrameTiles>();
		for (name => build in frameTilesBuilderMap)
			frameTilesMap.set(name, build(texture));

		return new Atlas(texture, frameTilesMap);
	}

	private static function processImageDataList(
		imageDataList: ImageDataList,
		destX: UInt,
		destY: UInt,
		entirePixels: Pixels,
		frameTilesBuilderMap: StringMap<(texture: Texture) -> FrameTiles>
	): PixelRegionSize {
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
				Pixels.blitAll(srcPixels, entirePixels, destX, destY);
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

	/**
		The entire texture.
	**/
	public final texture: Texture;

	final frameTilesMap: StringMap<FrameTiles>;

	public function new(texture: Texture, frameTilesMap: StringMap<FrameTiles>) {
		this.texture = texture;
		this.frameTilesMap = frameTilesMap;
	}

	/**
		@return The `FrameTiles` instance of `name`.
	**/
	public function get(name: String): FrameTiles {
		final tiles = this.frameTilesMap.get(name);
		if (tiles == null) throw 'Image data not registered: $name';
		return tiles;
	}
}
