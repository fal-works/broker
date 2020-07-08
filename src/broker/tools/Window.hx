package broker.tools;

import broker.sound.SoundManager;

/**
	Static fields related to the window.
**/
class Window {
	/**
		Function called when the window is closed.
	**/
	public static var onClose = () -> {};

	/**
		Initializes window.
	**/
	public static function initialize(): Void {
		#if heaps
		hxd.Window.getInstance().onClose = () -> {
			prepareClose();
			return true;
		};
		#end
	}

	/**
		Sets/unsets fullscreen mode.
		@param flag `true` for fullscreen, `false` for windowed.
	**/
	public static function fullscreen(flag: Bool): Void {
		#if heaps
		hxd.Window.getInstance().displayMode = if (flag) Fullscreen else Windowed;
		#end
	}

	/**
		Closes the window.
	**/
	public static function close() {
		prepareClose();

		#if heaps
		hxd.System.exit();
		#else
		Sys.exit(0);
		#end
	}

	static function prepareClose(): Void {
		SoundManager.disposeAll();
		onClose();
	}
}
