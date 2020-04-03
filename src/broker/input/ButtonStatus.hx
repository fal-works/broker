package broker.input;

/**
	Status of a specific gamepad button.
**/
class ButtonStatus {
	/**
		`true` if the buttons is currently pressed.
	**/
	public var isPressed = false;

	/**
		`true` if the buttan has been pressed in the most recent frame.
	**/
	public var isJustPressed = false;

	/**
		`true` if the buttan has been released in the most recent frame.
	**/
	public var isJustReleased = false;

	/**
		Increments while the button is pressed (starting with `0`).
		`-1` if not pressed.
	**/
	public var pressedFrameCount = -1;

	/**
		@see `new()`
	**/
	final buttonIsDown: () -> Bool;

	/**
		@param buttonIsDown Function internally used in `update()`
		for checking if the button should be considered pressed.
	**/
	public function new(buttonIsDown: () -> Bool)
		this.buttonIsDown = buttonIsDown;

	/**
		Updates all status of the button.
	**/
	public function update() {
		if (this.buttonIsDown()) {
			final frameCount = pressedFrameCount + 1;
			this.isPressed = true;
			this.isJustPressed = frameCount == 0;
			this.isJustReleased = false;
			this.pressedFrameCount = frameCount;
		} else {
			final pressed = this.isPressed;
			this.isPressed = false;
			this.isJustPressed = false;
			this.isJustReleased = pressed;
			this.pressedFrameCount = -1;
		}
	}
}
