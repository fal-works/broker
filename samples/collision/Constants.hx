package collision;

class Constants {
	public static var width(default, null): Int;
	public static var height(default, null): Int;

	public static function initialize(window: hxd.Window) {
		width = window.width;
		height = window.height;

		final spaceWidth = Std.int(Space.width);
		final spaceHeight = Std.int(Space.height);
		if (spaceWidth != width || spaceHeight != height)
			trace('Size of Space class ($spaceWidth, $spaceHeight) does not match to the actual window size ($width, $height).');
	}
}
