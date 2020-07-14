package broker.tools;

import sneaker.log.Logger;
import broker.sound.SoundManager;

/**
	Static fields related to the window.
**/
class Window {
	/**
		Flag for toggling fullscreen/windowed.

		Note: Changing the window state manually via the underlying engine (or ALT+ENTER) does not reflect to this value.
	**/
	public static var fullscreen(default, set): Bool = true;

	/**
		Function called when the window is closed.
	**/
	public static var onClose = () -> {};

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
		#elseif sys
		Sys.exit(0);
		#end
	}

	/**
		Initializes the window. Automatically called by `broker.App`.
	**/
	static function initialize(fullscreen: Bool): Void {
		#if heaps
		hxd.Window.getInstance().onClose = () -> {
			prepareClose();
			return true;
		};
		#end

		set_fullscreen(fullscreen);
	}

	static function prepareClose(): Void {
		SoundManager.disposeAll();
		onClose();
	}

	#if js
	static extern inline function set_fullscreen(flag: Bool): Bool
		return flag;
	#else
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
	#end
}
