package broker.input.builtin.simple;

/**
	A simple set of virtual buttons consisting of
	A, B, X, Y and cross direction buttons.
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
	var LEFT;

	/** Virtual up direction button. **/
	var UP;

	/** Virtual right direction button. **/
	var RIGHT;

	/** Virtual down direction button. **/
	var DOWN;
}
