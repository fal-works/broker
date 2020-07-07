package broker.input.heaps;

#if heaps
import hxd.Pad;

class HeapsPadTools {
	/**
		Registers an event listener so that every new `PhysicalGamepad` is connected to `PhysicalGamepadMultitap`.
	**/
	public static function initialize(): Void {
		Pad.wait(PhysicalGamepadMultitap.connect);
	}
}
#end
