package broker.image.heaps;

@:notNull
abstract Tile(h2d.Tile) from h2d.Tile to h2d.Tile {
	public static extern inline function fromImage(image: hxd.res.Image): Tile
		return image.toTile();

	public var width(get, never): UInt;
	public var height(get, never): UInt;

	/**
		@return A sub-tile from `this`.
	**/
	public extern inline function getSubTile(x: UInt, y: UInt, width: UInt, height: UInt): Tile
		return this.sub(x, y, width, height);

	/**
		@return A new `Tile` instance with the center of the tile as its origin point.
	**/
	public extern inline function toCentered(): Tile
		return this.center();

	extern inline function get_width()
		return Floats.toInt(this.width);

	extern inline function get_height()
		return Floats.toInt(this.height);
}
