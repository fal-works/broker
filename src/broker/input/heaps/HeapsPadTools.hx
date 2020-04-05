package broker.input.heaps;

#if heaps
using banker.type_extension.MapExtension;

import hxd.Pad;
import banker.vector.Vector;
import banker.vector.VectorReference;

@:access(broker.input.heaps.HeapsPadMultitap)
class HeapsPadTools {
	/**
		Null object for `hxd.Pad`.
	**/
	public static final dummyPad = Pad.createDummy();

	/**
		Registers an event listener so that every new `hxd.Pad` is connected to `HeapsPadMultitap`.
	**/
	public static function initialize() {
		Pad.wait(HeapsPadMultitap.connect);
	}

	/**
		@return `true` if any button in `buttonCodes` is down.
	**/
	public static function anyButtonIsDown(port: HeapsPadPort, buttonCodes: VectorReference<Int>): Bool {
		final buttons = port.get().buttons;
		for (i in 0...buttonCodes.length) {
			if (buttons[buttonCodes[i]]) return true;
		}
		return false;
	}

	/**
		@return Function that returns `true` if any button of `buttonCodeArray` is down.
	**/
	public static inline function createButtonCodesChecker<T>(
		port: HeapsPadPort,
		buttonCodeArray: Array<Int>
	): () -> Bool {
		final buttonCodes = Vector.fromArrayCopy(buttonCodeArray);
		return anyButtonIsDown.bind(port, buttonCodes);
	};

	/**
		Usage:

		```
		final generateChecker = createButtonCheckerGenerator(anyPort, anyButtonCodeMap);
		final checkerX = generateChecker(buttonX);
		final xIsDown = checkerX(); // true if buttonX is down
		```

		@param buttonCodeMap Mapping from virtual buttons to button codes used in `hxd.Pad`.
		@return Function that generates another function for checking if a given `button` is down.
	**/
	public static inline function createButtonCheckerGenerator<T>(
		port: HeapsPadPort,
		buttonCodeMap: Map<T, Array<Int>>
	): (button: T) -> (() -> Bool) {
		return function(button: T) {
			final buttonCodeArray = buttonCodeMap.getOr(button, []);
			return createButtonCodesChecker(port, buttonCodeArray);
		};
	}
}
#end
