package broker.image.heaps;

import broker.object.heaps.Object;

abstract TileDraw(h2d.Bitmap) from h2d.Bitmap to h2d.Bitmap to Object {
	/**
		Creates a `TileDraw` instance from `image`.
	**/
	public static extern inline function fromImage(image: hxd.res.Image): TileDraw
		return new TileDraw(image.toTile());

	public extern inline function new(tile: Tile) {
		this = new h2d.Bitmap(tile);
	}
}
