package broker.input.physical.heaps;

#if heaps
import banker.vector.VectorReference;

@:access(hxd.Key)
class Key {
	/**
		Registers an event listener so that `hxd.Key` is updated for every window event.
	**/
	public static function initialize() {
		hxd.Key.initialize();
		hxd.Key.keyPressed.resize(256);
	}

	/**
		@return `true` if the key of `keyCode` is down.
	**/
	public static inline function isDown(keyCode: KeyCode): Bool
		return 0 < hxd.Key.keyPressed[keyCode.code];

	/**
		@return `true` if any key in `keyCodes` is down.
	**/
	public static function anyKeyIsDown(keyCodes: VectorReference<KeyCode>): Bool {
		final keyPressed = hxd.Key.keyPressed;
		for (i in 0...keyCodes.length) {
			if (0 < keyPressed[keyCodes[i].code]) return true;
		}
		return false;
	}
}
#end
