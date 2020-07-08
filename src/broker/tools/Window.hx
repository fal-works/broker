package broker.tools;

import sneaker.log.Logger;
import broker.sound.SoundManager;

/**
	Static fields related to the window.
**/
class Window {
	/**
		`true` if the window is currently fullscreen.
	**/
	public static var fullscreen(default, set): Bool = false;

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
		Toggles the value of `fullscreen`.
		@return The value of `fullscreen` after toggled.
	**/
	public static function toggleFullscreen(): Bool
		return fullscreen = !fullscreen;

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

	static extern inline function set_fullscreen(flag: Bool): Bool {
		#if heaps
		final window = hxd.Window.getInstance();
		if (flag) {
			window.displayMode = Fullscreen;
		} else {
			window.displayMode = Windowed;
			window.resize(App.width, App.height);
		}
		#end

		Logger.debug('Set fullscreen: $flag');

		return fullscreen = flag;
	}
}
