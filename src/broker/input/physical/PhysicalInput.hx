package broker.input.physical;

/**
	Functions related to both `Key` and `Pad`.
**/
class PhysicalInput {
	/**
		Initializes both `broker.input.physical.Key` and `broker.input.physical.Pad`.
	**/
	public static function initialize(): Void {
		Key.initialize();
		Pad.initialize();
	}

	/**
		Creates a button checker function that checks both `KeyCode` and `PadCode`.
		@param keyCodeMap Mapping from virtual buttons to `KeyCode`.
		@param buttonCodeMap Mapping from virtual buttons to `PadCode`.
		@param padPort Any element of `PadMultitap.ports`.
		@return Function that generates another function for checking if a given `button` is down.
	**/
	public static inline function createButtonCheckerGenerator<T>(
		keyCodeMap: Map<T, Array<KeyCode>>,
		buttonCodeMap: Map<T, Array<PadCode>>,
		padPort: PadPort
	) {
		final generateCheckFromKey = Key.createButtonCheckerGenerator(keyCodeMap);

		final generateCheckFromPad = padPort.createButtonCheckerGenerator(buttonCodeMap);

		return function(button: T) {
			final checkFromKey = generateCheckFromKey(button);
			final checkFromPad = generateCheckFromPad(button);
			return () -> checkFromKey() || checkFromPad();
		};
	}
}
