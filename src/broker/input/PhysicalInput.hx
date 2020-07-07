package broker.input;

/**
	Functions related to both `Key` and `PhysicalGamepad`.
**/
class PhysicalInput {
	/**
		Creates a button checker function that checks both `KeyCode` and `ButtonCode`.
		@param keyCodeMap Mapping from virtual buttons to `KeyCode`.
		@param buttonCodeMap Mapping from virtual buttons to `ButtonCode`.
		@param padPort Any element of `PhysicalGamepadMultitap.ports`.
		@return Function that generates another function for checking if a given `button` is down.
	**/
	public static inline function createButtonCheckerGenerator<T>(
		keyCodeMap: Map<T, Array<KeyCode>>,
		buttonCodeMap: Map<T, Array<ButtonCode>>,
		padPort: PhysicalGamepadPort
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
