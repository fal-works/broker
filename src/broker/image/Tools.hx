package broker.image;

/**
	Common static fields for `image` package.
**/
class Tools {
	static final frameSizeRegexp = ~/[_](\d+)px[_\.]/i;

	/**
		Parses `fileName` and gets the values below:
		- Name of the image data
		- Size of each graphics frame
	**/
	public static function parseImageFileName(
		fileName: String
	): { name: String, frameSize: Maybe<PixelSize> } {
		if (frameSizeRegexp.match(fileName)) {
			final dataName = fileName.substr(0, frameSizeRegexp.matchedPos().pos);
			final frameSizeValue = Std.parseInt(frameSizeRegexp.matched(1));
			if (frameSizeValue != null) {
				final frameSize = new PixelSize(frameSizeValue, frameSizeValue);

				return { name: dataName, frameSize: Maybe.from(frameSize) };
			}
		}
		return { name: fileName.sliceBeforeLastDot(), frameSize: Maybe.none() };
	}
}
