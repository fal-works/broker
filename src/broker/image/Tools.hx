package broker.image;

/**
	Common static fields for `image` package.
**/
class Tools {
	static final frameSizeRegexp = ~/[_](\d+)px[_\.]/i; // e.g. somename_64px.png
	static final frameWHRegexp = ~/[_](\d+)x(\d+)px[_\.]/i; // e.g. somename_48x32px.png

	/**
		Parses `fileName` and gets the values below:
		- Name of the image data
		- Size of each graphics frame
	**/
	public static function parseImageFileName(
		fileName: String
	): { name: String, frameSize: Maybe<PixelRegionSize> } {
		if (frameSizeRegexp.match(fileName)) {
			final dataName = fileName.substr(0, frameSizeRegexp.matchedPos().pos);
			final frameSizeValue = Std.parseInt(frameSizeRegexp.matched(1));
			if (frameSizeValue != null) {
				final frameSize = new PixelRegionSize(frameSizeValue, frameSizeValue);
				return { name: dataName, frameSize: Maybe.from(frameSize) };
			}
		}

		if (frameWHRegexp.match(fileName)) {
			final dataName = fileName.substr(0, frameWHRegexp.matchedPos().pos);
			final frameWidthValue = Std.parseInt(frameWHRegexp.matched(1));
			final frameHeightValue = Std.parseInt(frameWHRegexp.matched(2));
			if (frameWidthValue != null && frameHeightValue != null) {
				final frameSize = new PixelRegionSize(
					frameWidthValue,
					frameHeightValue
				);
				return { name: dataName, frameSize: Maybe.from(frameSize) };
			}
		}

		return { name: fileName.sliceBeforeLastDot(), frameSize: Maybe.none() };
	}
}
