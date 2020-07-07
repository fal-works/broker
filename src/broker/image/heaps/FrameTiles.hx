package broker.image.heaps;

@:notNull @:forward
abstract FrameTiles(Vector<Tile>) from Vector<Tile> to Vector<Tile> {
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
		texture: Texture,
		x: UInt,
		y: UInt,
		width: UInt,
		height: UInt,
		tileSize: Maybe<PixelSize>,
		center = true
	): FrameTiles {
		var entire = texture.getEntireTile().getSubTile(x, y, width, height);
		final entireWidth = entire.width;
		final entireHeight = entire.height;
		final frames: Array<Tile> = [];

		if (tileSize.isSome()) {
			final tileWidth = tileSize.unwrap().width;
			final tileHeight = tileSize.unwrap().height;
			var x = UInt.zero;
			var y = UInt.zero;
			while (y < entireHeight) {
				while (x < entireWidth) {
					var tile = entire.getSubTile(x, y, tileWidth, tileHeight);
					if (center) tile = tile.toCentered();
					frames.push(tile);
					x += tileWidth;
				}
				x = UInt.zero;
				y += tileHeight;
			}
		}

		return Vector.fromArrayCopy(frames);
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

	@:op([]) public extern inline function get(index: UInt): Tile
		return this[index];
}
