package broker.image.heaps;

@:notNull
abstract Texture(h3d.mat.Texture) from h3d.mat.Texture to h3d.mat.Texture {
	public static extern inline function fromImage(image: hxd.res.Image): Texture
		return image.toTexture();

	public static extern inline function fromPixels(pixels: Bitmap): Texture
		return h3d.mat.Texture.fromPixels(pixels);

	public extern inline function getEntireTile(): Tile
		return h2d.Tile.fromTexture(this);
}
