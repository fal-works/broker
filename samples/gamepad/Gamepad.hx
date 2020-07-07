package gamepad;

import broker.input.GamepadBase;
import broker.input.Stick;
import broker.input.KeyCode;
import broker.input.ButtonCode;
import broker.input.PhysicalGamepadPort;
import broker.input.PhysicalGamepadMultitap;
import broker.input.heaps.HeapsInputTools;
import broker.input.builtin.simple.Button;
import broker.input.builtin.simple.ButtonStatusMap;

/**
	An example of gamepad implementation.
**/
class Gamepad extends GamepadBase<Button, ButtonStatusMap, Stick> {
	static inline final analogStickThreshold = 0.1;

	final port: PhysicalGamepadPort;
	final updateButtonStatus: () -> Void;
	final moveSpeed: Float;

	public function new(padPortIndex: Int, moveSpeed: Float) {
		super(new ButtonStatusMap(), new Stick());

		this.port = PhysicalGamepadMultitap.ports[padPortIndex];

		final getButtonChecker = HeapsInputTools.createButtonCheckerGenerator(
			GamepadSettings.keyCodeMap,
			GamepadSettings.padButtonCodeMap,
			this.port
		);
		this.updateButtonStatus = this.buttons.createUpdater(getButtonChecker);

		this.moveSpeed = moveSpeed;
	}

	/**
		This example does:
		1. Update `this.buttons` by keyboard and physical gamepad (prepared in `new()`).
		2. Update `this.stick` by D-Pad buttons in `this.buttons`.
		3. If no D-Pad input detected, update `this.stick` by analog stick of physical gamepad.
	**/
	override public function update() {
		// update this.buttons
		updateButtonStatus();

		// reflect: this.buttons => this.stick
		final movedWithDpad = buttons.reflectToStick(stick);
		if (movedWithDpad) {
			stick.multiplyDistance(moveSpeed);
			return;
		}

		// reflect: physical analog stick => this.stick
		port.updateStick(stick);

		if (stick.distance > analogStickThreshold)
			stick.multiplyDistance(moveSpeed);
		else
			stick.reset();
	}
}

class GamepadSettings {
	/**
		Mapping from virtual buttons to `KeyCode` values.
	**/
	public static final keyCodeMap: Map<Button, Array<KeyCode>> = [
		A => [KeyCode.Z],
		B => [KeyCode.X],
		X => [KeyCode.SHIFT],
		Y => [KeyCode.ESC],
		D_LEFT => [KeyCode.LEFT],
		D_UP => [KeyCode.UP],
		D_RIGHT => [KeyCode.RIGHT],
		D_DOWN => [KeyCode.DOWN]
	];

	/**
		Mapping from virtual buttons to `hxd.Pad` button codes.
	**/
	public static final padButtonCodeMap: Map<Button, Array<ButtonCode>> = [
		A => [ButtonCode.A],
		B => [ButtonCode.B],
		X => [ButtonCode.X],
		Y => [ButtonCode.Y],
		D_LEFT => [ButtonCode.LEFT],
		D_UP => [ButtonCode.UP],
		D_RIGHT => [ButtonCode.RIGHT],
		D_DOWN => [ButtonCode.DOWN]
	];
}
