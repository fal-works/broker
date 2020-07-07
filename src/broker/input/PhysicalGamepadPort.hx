package broker.input;

import banker.types.Reference;
import banker.vector.Vector;
import banker.vector.VectorReference;
import broker.input.interfaces.FullGamepad;
import broker.input.interfaces.ButtonStatusMapWithDpad as ButtonsWithDpad;

using banker.type_extension.MapExtension;

private typedef Data = Reference<PhysicalGamepad>;

/**
	Virtual port for connecting `PhysicalGamepad`.
**/
@:forward(get, set)
abstract PhysicalGamepadPort(Data) from Data {
	public extern inline function new(pad: Reference<PhysicalGamepad>)
		this = pad;

	/**
		@return `true` if any button in `buttonCodes` is down.
	**/
	public function anyButtonIsDown(buttonCodes: VectorReference<ButtonCode>): Bool {
		return this.get().anyButtonIsDown(buttonCodes);
	}

	/**
		@return Function that returns `true` if any button of `buttonCodeArray` is down.
	**/
	public inline function createButtonCodesChecker<T>(
		buttonCodeArray: Array<ButtonCode>
	): () -> Bool {
		final buttonCodes = Vector.fromArrayCopy(buttonCodeArray);
		return anyButtonIsDown.bind(buttonCodes);
	};

	/**
		Usage:

		```
		final generateChecker = createButtonCheckerGenerator(anyPort, anyButtonCodeMap);
		final checkerX = generateChecker(buttonX);
		final xIsDown = checkerX(); // true if buttonX is down
		```

		@param buttonCodeMap Mapping from virtual buttons to button codes used in `hxd.Pad`.
		@return Function that generates another function for checking if a given `button` is down.
	**/
	public inline function createButtonCheckerGenerator<T>(
		buttonCodeMap: Map<T, Array<ButtonCode>>
	): (button: T) -> (() -> Bool) {
		return function(button: T) {
			final buttonCodeArray = buttonCodeMap.getOr(button, []);
			return createButtonCodesChecker(buttonCodeArray);
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
