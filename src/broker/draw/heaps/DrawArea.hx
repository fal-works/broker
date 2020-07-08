package broker.draw.heaps;

import h2d.Mask;
import broker.object.Object;

/**
	Rendering area.
**/
@:notNull @:forward(x, y, setPosition, addChild, removeChild, removeChildren)
abstract DrawArea(Mask) to Object {
	public var width(get, set): UInt;
	public var height(get, set): UInt;

	public extern inline function new(width: UInt, height: UInt) {
		this = new Mask(width, height);
	}

	extern inline function get_width()
		return this.width;

	extern inline function set_width(v: UInt)
		return this.width = v;

	extern inline function get_height()
		return this.height;

	extern inline function set_height(v: UInt)
		return this.height = v;
}
