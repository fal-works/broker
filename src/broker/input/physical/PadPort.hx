package broker.input.physical;

import banker.types.Reference;
import banker.vector.Vector;
import banker.vector.VectorReference;
import broker.input.interfaces.FullGamepad;
import broker.input.interfaces.ButtonStatusMapWithDpad as ButtonsWithDpad;

using banker.type_extension.MapExtension;

private typedef Data = Reference<Pad>;

/**
	Virtual port for connecting `Pad`.
**/
@:forward(get, set)
abstract PadPort(Data) from Data {
	public extern inline function new(pad: Reference<Pad>)
		this = pad;

	/**
		@return `true` if any button in `buttonCodes` is down.
	**/
	public function anyButtonIsDown(buttonCodes: VectorReference<PadCode>): Bool {
		return this.get().anyButtonIsDown(buttonCodes);
	}

	/**
		@return Function that returns `true` if any button of `buttonCodeArray` is down.
	**/
	public inline function createPadCodesChecker<T>(
		buttonCodeArray: Array<PadCode>
	): () -> Bool {
		final buttonCodes = Vector.fromArrayCopy(buttonCodeArray);
		return anyButtonIsDown.bind(buttonCodes);
	};

	/**
		Usage:

		```
		final generateChecker = createButtonCheckerGenerator(anyPort, anyPadCodeMap);
		final checkerX = generateChecker(buttonX);
		final xIsDown = checkerX(); // true if buttonX is down
		```

		@param buttonCodeMap Mapping from virtual buttons to button codes used in `hxd.Pad`.
		@return Function that generates another function for checking if a given `button` is down.
	**/
	public inline function createButtonCheckerGenerator<T>(
		buttonCodeMap: Map<T, Array<PadCode>>
	): (button: T) -> (() -> Bool) {
		return function(button: T) {
			final buttonCodeArray = buttonCodeMap.getOr(button, []);
			return createPadCodesChecker(buttonCodeArray);
		};
	}

	/**
		Updates `stick` according to the main (= likely the left) analog stick values
		of the gamepad at `this` port.
	**/
	public inline function updateStick(stick: Stick): Void
		this.get().updateStick(stick);

	/**
		Updates `stick` according to left analog stick values of the gamepad at `this` port.
	**/
	public inline function updateStickFromLeftAnalog(stick: Stick): Void
		this.get().updateStickFromLeftAnalog(stick);

	/**
		Updates `stick` according to right analog stick values of the gamepad at `this` port.
	**/
	public inline function updateStickFromRightAnalog(stick: Stick): Void
		this.get().updateStickFromRightAnalog(stick);

	/**
		Updates `leftStick` and `rightStick` according to left/right analog sticks
		of the gamepad at `this` port.
	**/
	public inline function updateSticks(leftStick: Stick, rightStick: Stick): Void
		this.get().updateSticks(leftStick, rightStick);

	/**
		Updates trigger buttons of `gamepad` according to `this` values.
	**/
	public inline function updateTriggers<B, M: ButtonsWithDpad<B>, S: Stick>(
		gamepad: FullGamepad<B, M, S>
	): Void {
		this.get().updateTriggers(gamepad);
	}
}
