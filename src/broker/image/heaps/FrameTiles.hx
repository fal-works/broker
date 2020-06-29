package broker.image.heaps;

import broker.image.common.FrameTiles as FrameTilesBase;

class FrameTiles extends FrameTilesBase {
	/**
		Creates a `FrameTiles` instance from `texture`.
		@param x The left-top point of the source area in `texture`.
		@param y Ditto.
		@param width The size of the source area in `texture`.
		@param height Ditto.
		@param tileSize The size of each graphics frame sub-tile.
		@param center If `true`, applies `center()` to all sub-tiles.
	**/
	public static function fromData(
		texture: h3d.mat.Texture,
		x: UInt,
		y: UInt,
		width: UInt,
		height: UInt,
		tileSize: Maybe<PixelSize>,
		center = true
	): FrameTiles {
		var entire = h2d.Tile.fromTexture(texture).sub(x, y, width, height);
		final frames: Array<Tile> = [];

		if (tileSize.isSome()) {
			final tileWidth: Float = tileSize.unwrap().width;
			final tileHeight: Float = tileSize.unwrap().height;
			var x = 0.0;
			var y = 0.0;
			while (y < entire.height) {
				while (x < entire.width) {
					var tile = entire.sub(x, y, tileWidth, tileHeight);
					if (center) tile = tile.center();
					frames.push(tile);
					x += tileWidth;
				}
				x = 0.0;
				y += tileHeight;
			}
		}

		return new FrameTiles(entire, Vector.fromArrayCopy(frames));
	}

	/**
		Creates a `FrameTiles` instance from `image`.
		Also tries to determine the graphics frame size according to the file name of `image`.
		@param center If `true`, applies `center()` to all sub-tiles.
	**/
	public static function fromImage(image: hxd.res.Image, center = true): FrameTiles {
		final entireTile = image.toTile();
		final imageSize = image.getSize();

		return fromData(
			entireTile.getTexture(),
			UInt.zero,
			UInt.zero,
			imageSize.width,
			imageSize.height,
			Tools.parseImageFileName(image.name).frameSize,
			center
		);
	}
}
