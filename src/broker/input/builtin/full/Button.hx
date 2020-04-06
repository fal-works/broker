package broker.input.builtin.full;

/**
	A full set of virtual buttons (respecting X-BOX controller).
**/
enum abstract Button(Int) {
	/** Virtual A button. **/
	var A;

	/** Virtual A button. **/
	var B;

	/** Virtual X button. **/
	var X;

	/** Virtual Y button. **/
	var Y;

	/** Virtual left direction button. **/
	var D_LEFT;

	/** Virtual up direction button. **/
	var D_UP;

	/** Virtual right direction button. **/
	var D_RIGHT;

	/** Virtual down direction button. **/
	var D_DOWN;

	/** Virtual left bumper button. **/
	var LB;

	/** Virtual right bumper button. **/
	var RB;

	/** Virtual left trigger button. **/
	var LT;

	/** Virtual right trigger button. **/
	var RT;

	/** Click of virtual left analog stick. **/
	var LEFT_STICK_CLICK;

	/** Click of virtual right analog stick. **/
	var RIGHT_STICK_CLICK;

	/** Virtual start button. **/
	var START;

	/** Virtual back button. **/
	var BACK;
}
