package broker.image.heaps;

@:notNull
abstract Tile(h2d.Tile) from h2d.Tile to h2d.Tile {
	public static extern inline function fromImage(image: hxd.res.Image): Tile
		return image.toTile();
}
