package broker.input.physical;

#if heaps
import broker.input.physical.heaps.Pad as Data;

@:notNull @:forward @:forwardStatics
abstract Pad(Data) from Data to Data {
	/**
		Initializes gamepad feature.
		Automatically called by `broker.App`.
	**/
	static function initialize(): Void
		Data.initialize();
}
#end
