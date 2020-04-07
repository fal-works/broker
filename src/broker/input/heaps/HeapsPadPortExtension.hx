package broker.input.heaps;

#if heaps
import broker.input.interfaces.FullGamepad;
import broker.input.interfaces.ButtonStatusMapWithDpad as ButtonsWithDpad;
import banker.vector.Vector;
import banker.vector.VectorReference;

using banker.type_extension.MapExtension;

class HeapsPadPortExtension {
	/**
		@return `true` if any button in `buttonCodes` is down.
	**/
	public static function anyButtonIsDown(
		port: HeapsPadPort,
		buttonCodes: VectorReference<Int>
	): Bool {
		final buttons = port.get().buttons;
		for (i in 0...buttonCodes.length) {
			if (buttons[buttonCodes[i]]) return true;
		}
		return false;
	}

	/**
		@return Function that returns `true` if any button of `buttonCodeArray` is down.
	**/
	public static inline function createButtonCodesChecker<T>(
		_this: HeapsPadPort,
		buttonCodeArray: Array<Int>
	): () -> Bool {
		final buttonCodes = Vector.fromArrayCopy(buttonCodeArray);
		return anyButtonIsDown.bind(_this, buttonCodes);
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
	public static inline function createButtonCheckerGenerator<T>(
		_this: HeapsPadPort,
		buttonCodeMap: Map<T, Array<Int>>
	): (button: T) -> (() -> Bool) {
		return function(button: T) {
			final buttonCodeArray = buttonCodeMap.getOr(button, []);
			return createButtonCodesChecker(_this, buttonCodeArray);
		};
	}

	/**
		Updates `stick` according to the main (= likely the left) analog stick values
		of the gamepad at `this` port.
	**/
	public static function updateStick(_this: HeapsPadPort, stick: Stick): Void {
		final pad = _this.get();
		stick.setCartesian(pad.xAxis, pad.yAxis);
	}

	/**
		Updates `stick` according to left analog stick values of the gamepad at `this` port.
	**/
	public static function updateStickFromLeftAnalog(
		_this: HeapsPadPort,
		stick: Stick
	): Void {
		final pad = _this.get();
		final config = pad.config;
		final padValues = pad.values;

		stick.setCartesian(padValues[config.analogX], -padValues[config.analogY]);
	}

	/**
		Updates `stick` according to right analog stick values of the gamepad at `this` port.
	**/
	public static function updateStickFromRightAnalog(
		_this: HeapsPadPort,
		stick: Stick
	): Void {
		final pad = _this.get();
		final config = pad.config;
		final padValues = pad.values;

		stick.setCartesian(padValues[config.ranalogX], -padValues[config.ranalogY]);
	}

	/**
		Updates `stick` according to right analog stick values of the gamepad at `this` port.
	**/
	public static function updateSticks(
		_this: HeapsPadPort,
		leftStick: Stick,
		rightStick: Stick
	): Void {
		final pad = _this.get();
		final config = pad.config;
		final padValues = pad.values;

		leftStick.setCartesian(
			padValues[config.analogX],
			-padValues[config.analogY]
		);

		rightStick.setCartesian(
			padValues[config.ranalogX],
			-padValues[config.ranalogY]
		);
	}

	/**
		Updates trigger buttons of `gamepad` according to `this` values.
	**/
	public static inline function updateTriggers<B, M: ButtonsWithDpad<B>, S: Stick>(
		_this: HeapsPadPort,
		gamepad: FullGamepad<B, M, S>
	): Void {
		final pad = _this.get();
		final config = pad.config;
		final padValues = pad.values;

		gamepad.reflectTriggers(padValues[config.LT], padValues[config.RT]);
	}
}
#end
