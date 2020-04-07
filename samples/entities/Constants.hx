package entities;

class Constants {
	public static var width(default, null): Int;
	public static var height(default, null): Int;

	public static function initialize(window: hxd.Window) {
		width = window.width;
		height = window.height;
	}
}
