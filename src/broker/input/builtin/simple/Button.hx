package broker.input.builtin.simple;

/**
	A simple set of virtual buttons consisting of
	A, B, X, Y and 4 direction buttons.
**/
enum abstract Button(Int) {
	var A;
	var B;
	var X;
	var Y;
	var LEFT;
	var UP;
	var RIGHT;
	var DOWN;
}
