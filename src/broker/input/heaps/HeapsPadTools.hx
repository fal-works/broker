package broker.input.heaps;

#if heaps
import hxd.Pad;

class HeapsPadTools {
	/**
		Null object for `hxd.Pad`.
	**/
	public static final dummyPad = Pad.createDummy();

	/**
		Registers an event listener so that every new `hxd.Pad` is connected to `HeapsPadMultitap`.
	**/
	public static function initialize(): Void {
		Pad.wait(HeapsPadMultitap.connect);
	}
}
#end
