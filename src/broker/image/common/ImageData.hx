package broker.image.common;

@:structInit
class ImageData implements ripper.Data {
	/**
		Pixels data.
	**/
	public final bitmap: Bitmap;

	/**
		The name of `this` image.
	**/
	public final name: String;

	/**
		If specified, `this` image is interpreted as animation of graphics frames with a fixed size.
	**/
	public final frameSize: Maybe<PixelSize>;

	/**
		`true` for applying `center()` to all sub-tiles.
	**/
	public final centerPivot: Bool;
}
