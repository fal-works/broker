package broker.image.common;

/**
	Common static fields for `image` package.
**/
class Tools {
	static final tileSizeRegexp = ~/[_](\d+)px[_\.]/i;

	/**
		Parses `fileName` and tries to get the size of each graphics frame.
	**/
	public static function getFrameSize(fileName: String): Maybe<PixelSize> {
		if (tileSizeRegexp.match(fileName)) {
			final tileSizeValue = Std.parseInt(tileSizeRegexp.matched(1));
			if (tileSizeValue != null) {
				final tileSize: UInt = tileSizeValue;
				return Maybe.from({ width: tileSize, height: tileSize });
			}
		}
		return Maybe.none();
	}
}
