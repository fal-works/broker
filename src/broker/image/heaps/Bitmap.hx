package broker.image.heaps;

abstract Bitmap(hxd.Pixels) from hxd.Pixels to hxd.Pixels {
	/**
		Blits pixels from `src` to `dest`.
	**/
	public static inline function blit(
		src: Bitmap,
		srcX: UInt,
		srcY: UInt,
		dest: Bitmap,
		destX: UInt,
		destY: UInt,
		width: UInt,
		height: UInt
	): Void {
		dest.toHeapsPixels().blit(destX, destY, src, srcX, srcY, width, height);
	}

	public var width(get, never): UInt;
	public var height(get, never): UInt;

	public extern inline function new(width: UInt, height: UInt)
		this = hxd.Pixels.alloc(width, height, BGRA);

	public extern inline function dispose(): Void
		this.dispose();

	/**
		Casts `this` to the underlying `hxd.Pixels`.
	**/
	public extern inline function toHeapsPixels(): hxd.Pixels
		return this;

	extern inline function get_width()
		return this.width;

	extern inline function get_height()
		return this.height;
}
