package broker.scene;

import broker.object.internal.ObjectData;

/**
	Drawing layer.
**/
@:notNull @:forward(setFilter)
abstract Layer(Object) from Object to Object {
	/**
		`this` as the underlying type.
	**/
	public var data(get, never): ObjectData;

	public extern inline function new() {
		this = new Object();
	}

	public extern inline function add(object: Object): Void
		this.addChild(object);

	public extern inline function remove(object: Object): Void
		this.removeChild(object);

	public extern inline function clear(): Void
		this.removeChildren();

	extern inline function get_data()
		return this.data;
}
