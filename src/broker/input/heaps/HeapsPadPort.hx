package broker.input.heaps;

/**
	Virtual port for connecting physical gamepad (i.e. `hxd.Pad` instance).
**/
@:using(broker.input.heaps.HeapsPadPort.HeapsPadPortExtension)
@:forward
@:forwardStatics
abstract HeapsPadPort(banker.types.Reference<hxd.Pad>) from banker.types.Reference<hxd.Pad> to banker.types.Reference<hxd.Pad> {}

class HeapsPadPortExtension {
	/**
		Updates `stick` according to left analog stick values of the gamepad at `this` port.
	**/
	public static function updateStickFromLeftAnalog(_this: HeapsPadPort, stick: Stick): Void {
		final pad = _this.get();
		final config = pad.config;
		final padValues = pad.values;

		final x = padValues[config.analogX];
		final y = -padValues[config.analogY];
		stick.setCartesian(x, y);
	}

	/**
		Updates `stick` according to right analog stick values of the gamepad at `this` port.
	**/
	public static function updateStickFromRightAnalog(_this: HeapsPadPort, stick: Stick): Void {
		final pad = _this.get();
		final config = pad.config;
		final padValues = pad.values;

		final x = padValues[config.ranalogX];
		final y = -padValues[config.ranalogY];
		stick.setCartesian(x, y);
	}
}
