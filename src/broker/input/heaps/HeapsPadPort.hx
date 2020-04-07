package broker.input.heaps;

import hxd.Pad;
import banker.types.Reference;

/**
	Virtual port for connecting physical gamepad (i.e. `hxd.Pad` instance).
**/
@:using(broker.input.heaps.HeapsPadPortExtension)
@:forward
@:forwardStatics
abstract HeapsPadPort(Reference<Pad>) from Reference<Pad> to Reference<Pad> {}
