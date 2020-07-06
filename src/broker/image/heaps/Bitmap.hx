package broker.image.heaps;

private typedef Data = hxd.Pixels;

@:notNull
abstract Bitmap(Data) from Data to Data {
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
		dest.data.blit(destX, destY, src, srcX, srcY, width, height);
	}

	/**
		Blits the entire pixels of `src` to `dest`.
	**/
	public static inline function blitAll(
		src: Bitmap,
		dest: Bitmap,
		destX: UInt,
		destY: UInt
	): Void {
		blit(src, UInt.zero, UInt.zero, dest, destX, destY, src.width, src.height);
	}

	/**
		`this` as the underlying type.
	**/
	public var data(get, never): Data;

	public var width(get, never): UInt;
	public var height(get, never): UInt;

	public extern inline function new(width: UInt, height: UInt)
		this = hxd.Pixels.alloc(width, height, BGRA);

	public extern inline function dispose(): Void
		this.dispose();

	extern inline function get_data()
		return this;

	extern inline function get_width()
		return this.width;

	extern inline function get_height()
		return this.height;
}
