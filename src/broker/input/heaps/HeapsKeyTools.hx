package broker.input.heaps;

#if heaps
using banker.type_extension.MapExtension;

import hxd.Key;
import banker.vector.VectorReference;
import banker.vector.Vector;

@:access(hxd.Key)
class HeapsKeyTools {
	/**
		Registers an event listener so that `hxd.Key` is updated for every window event.
	**/
	public static function initialize() {
		Key.initialize();
		Key.keyPressed.resize(256);
	}

	/**
		@return `true` if any key in `keyCodes` is down.
	**/
	public static function anyKeyIsDown(keyCodes: VectorReference<Int>): Bool {
		final keyPressed = Key.keyPressed;
		for (i in 0...keyCodes.length) {
			if (0 < keyPressed[keyCodes[i]]) return true;
		}
		return false;
	}

	/**
		@return Function that returns `true` if any key of `keyCodeArray` is down.
	**/
	public static inline function createKeyCodesChecker<T>(
		keyCodeArray: Array<Int>
	): () -> Bool {
		final keyCodes = Vector.fromArrayCopy(keyCodeArray);
		return anyKeyIsDown.bind(keyCodes);
	};

	/**
		Usage:

		```
		final generateChecker = createButtonCheckerGenerator(anyKeyCodeMap);
		final checkerX = generateChecker(buttonX);
		final xIsDown = checkerX(); // true if buttonX is down
		```

		@return Function that generates another function for checking if a given `button` is down.
	**/
	public static inline function createButtonCheckerGenerator<T>(
		keyCodeMap: Map<T, Array<Int>>
	): (button: T) -> (() -> Bool) {
		return function(button: T) {
			final keyCodeArray = keyCodeMap.getOr(button, []);
			return createKeyCodesChecker(keyCodeArray);
		};
	}
}
#end
