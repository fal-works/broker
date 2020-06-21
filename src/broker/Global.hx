package broker;

/**
	Static fields for global use.
**/
class Global {
	/**
		Total frame count elapsed.
	**/
	public static var frameCount: UInt;

	/**
		Increments `frameCount`.
		Call this method every frame.
	**/
	public static inline function tick(): Void {
		++frameCount;
	}
}
