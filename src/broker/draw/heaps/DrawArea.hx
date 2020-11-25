package broker.draw.heaps;

import h2d.Mask;
import broker.object.Object;

/**
	Rendering area.
**/
@:notNull @:forward(x, y, scaleX, scaleY, scale, setScale, setPosition, visible)
@:using(broker.object.ObjectExtension)
abstract DrawArea(Mask) to Object {
	public var width(get, set): UInt;
	public var height(get, set): UInt;

	public extern inline function new(width: UInt, height: UInt) {
		this = new Mask(width, height);
	}

	public extern inline function asObject(): Object
		return this;

	/**
		Sets `this` position centered at `(x, y)`.
	**/
	public extern inline function setCenterPosition(x: Float, y: Float): Void
		this.setPosition(x - 0.5 * this.width, y - 0.5 * this.height);

	public extern inline function add(object: Object): Void
		this.addChild(object);

	public extern inline function remove(object: Object): Void
		this.removeChild(object);

	public extern inline function clear(): Void
		this.removeChildren();

	extern inline function get_width()
		return this.width;

	extern inline function set_width(v: UInt)
		return this.width = v;

	extern inline function get_height()
		return this.height;

	extern inline function set_height(v: UInt)
		return this.height = v;
}
