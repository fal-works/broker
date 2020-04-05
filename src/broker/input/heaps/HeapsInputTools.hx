package broker.input.heaps;

/**
	Functions related to both `hxd.Key` and `hxd.Pad`.
**/
class HeapsInputTools {
	/**
		Creates a button checker function that checks both `hxd.Key` and `hxd.Pad`.
		@param keyCodeMap Mapping from virtual buttons to key codes in `hxd.Key`.
		@param padButtonCodeMap Mapping from virtual buttons to button codes used in `hxd.Pad`.
		@param padPortIndex Index of `HeapsPadMultitap.ports`.
		@return Function that generates another function for checking if a given `button` is down.
	**/
	public static inline function createButtonChecker<T>(
		keyCodeMap: Map<T, Array<Int>>,
		padButtonCodeMap: Map<T, Array<Int>>,
		padPortIndex: Int
	) {
		final generateCheckFromKey = HeapsKeyTools.createButtonCheckerGenerator(keyCodeMap);

		final port = HeapsPadMultitap.ports[padPortIndex];
		final generateCheckFromPad = HeapsPadTools.createButtonCheckerGenerator(
			port,
			padButtonCodeMap
		);

		return function(button: T) {
			final checkFromKey = generateCheckFromKey(button);
			final checkFromPad = generateCheckFromPad(button);
			return () -> checkFromKey() || checkFromPad();
		};
	}
}
