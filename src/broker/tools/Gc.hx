package broker.tools;

/**
	Features related to Garbage Collection.
	*Not implemented (no effect) on this platform.*
**/
class Gc {
	public static inline function update(): Void {}

	public static inline function startProfile(): Void {}

	public static inline function stopProfile(): Void {}

	public static inline function startLogging(
		logIntervalDuration: UInt,
		flushIntervalDuration: MaybeUInt = MaybeUInt.none
	): Void {}

	public static inline function stopLogging(): Void {}
}
