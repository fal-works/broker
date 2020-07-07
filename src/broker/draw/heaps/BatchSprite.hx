package broker.draw.heaps;

import broker.color.Alpha;
import h2d.SpriteBatch.BatchElement as Data;

/**
	Element that can be added to `BatchDraw`.
**/
@:notNull @:forward(x, y, scale, rotation, visible)
abstract BatchSprite(Data) from Data to Data {
	/**
		`this` as the underlying type.
	**/
	public var data(get, never): Data;

	/**
		Current `Tile` to be drawn.
	**/
	public var tile(get, set): Tile;

	/**
		Current alpha value of `this` sprite.
	**/
	public var alpha(get, set): Alpha;

	/**
		@param tile The initial `Tile` to be set.
	**/
	public extern inline function new(tile: Tile)
		this = new Data(tile);

	extern inline function get_data()
		return this;

	extern inline function get_tile()
		return this.t;

	extern inline function set_tile(tile: Tile)
		return this.t = tile;

	extern inline function get_alpha()
		return Alpha.fromUnsafe(this.alpha);

	extern inline function set_alpha(v: Alpha)
		return Alpha.fromUnsafe(this.alpha = v.float());
}
