package broker.object.heaps;

#if heaps
import broker.object.internal.ObjectData;

@:forward(x, y, setPosition, addChild, removeChild, removeChildren)
@:using(broker.object.heaps.ObjectExtension)
abstract Object(ObjectData) from ObjectData to ObjectData {
	/**
		`this` as the underlying type.
	**/
	public var data(get, never): ObjectData;

	public extern inline function new() {
		this = new ObjectData();
	}

	extern inline function get_data()
		return this;
}
#end
