package broker.input;

import banker.vector.VectorReference;
import banker.vector.Vector;
#if heaps
import broker.input.heaps.HeapsKey as KeyImpl;
#end

using banker.type_extension.MapExtension;

/**
	Static functions for detecting keyboard input.
**/
class Key {
	/**
		Registers an event listener so that `hxd.Key` is updated for every window event.
	**/
	public static function initialize()
		KeyImpl.initialize();

	/**
		@return `true` if the key of `keyCode` is down.
	**/
	public static inline function isDown(keyCode: KeyCode): Bool
		return KeyImpl.isDown(keyCode);

	/**
		@return `true` if any key in `keyCodes` is down.
	**/
	public static inline function anyKeyIsDown(keyCodes: VectorReference<KeyCode>): Bool
		return KeyImpl.anyKeyIsDown(keyCodes);

	/**
		@return Function that returns `true` if any key of `keyCodeArray` is down.
	**/
	public static inline function createKeyCodesChecker<T>(
		keyCodeArray: Array<KeyCode>
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
	public static function createButtonCheckerGenerator<T>(
		keyCodeMap: Map<T, Array<KeyCode>>
	): (button: T) -> (() -> Bool) {
		return function(button: T) {
			final keyCodeArray = keyCodeMap.getOr(button, []);
			return createKeyCodesChecker(keyCodeArray);
		};
	}
}
