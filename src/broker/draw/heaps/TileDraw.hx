package broker.draw.heaps;

import broker.object.heaps.Object;

/**
	Object that draws a single tile.
**/
abstract TileDraw(h2d.Bitmap) from h2d.Bitmap to h2d.Bitmap to Object {
	/**
		Creates a `TileDraw` instance from `image`.
	**/
	public static extern inline function fromImage(image: hxd.res.Image): TileDraw {
		return new TileDraw(image.toTile());
	}

	public var tile(get, never): Tile;

	public extern inline function new(tile: Tile) {
		this = new h2d.Bitmap(tile);
	}

	extern inline function get_tile()
		return this.tile;
}
