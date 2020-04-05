package broker.input.heaps;

#if heaps
import hxd.Pad;
import banker.vector.Vector;
import banker.vector.VectorReference;

@:access(broker.input.heaps.HeapsPadMultitap)
class HeapsPadTools {
	public static final dummyPad = Pad.createDummy();

	public static function initialize() {
		Pad.wait(HeapsPadMultitap.onNewPad);
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

}
#end
