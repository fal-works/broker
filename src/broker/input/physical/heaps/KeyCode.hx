package broker.input.physical.heaps;

#if heaps
import hxd.Key;

/**
	Value that specifies a key of keyboard.
**/
abstract KeyCode(Int) {
	public static extern inline final BACKSPACE = from(Key.BACKSPACE);
	public static extern inline final TAB = from(Key.TAB);
	public static extern inline final ENTER = from(Key.ENTER);
	public static extern inline final SHIFT = from(Key.SHIFT);
	public static extern inline final CTRL = from(Key.CTRL);
	public static extern inline final ALT = from(Key.ALT);
	public static extern inline final ESC = from(Key.ESCAPE);
	public static extern inline final SPACE = from(Key.SPACE);

	public static extern inline final LEFT = from(Key.LEFT);
	public static extern inline final UP = from(Key.UP);
	public static extern inline final RIGHT = from(Key.RIGHT);
	public static extern inline final DOWN = from(Key.DOWN);

	public static extern inline final N1 = from(Key.NUMBER_1);
	public static extern inline final N2 = from(Key.NUMBER_2);
	public static extern inline final N3 = from(Key.NUMBER_3);
	public static extern inline final N4 = from(Key.NUMBER_4);
	public static extern inline final N5 = from(Key.NUMBER_5);
	public static extern inline final N6 = from(Key.NUMBER_6);
	public static extern inline final N7 = from(Key.NUMBER_7);
	public static extern inline final N8 = from(Key.NUMBER_8);
	public static extern inline final N9 = from(Key.NUMBER_9);
	public static extern inline final N0 = from(Key.NUMBER_0);

	public static extern inline final A = from(Key.A);
	public static extern inline final B = from(Key.B);
	public static extern inline final C = from(Key.C);
	public static extern inline final D = from(Key.D);
	public static extern inline final E = from(Key.E);
	public static extern inline final F = from(Key.F);
	public static extern inline final G = from(Key.G);
	public static extern inline final H = from(Key.H);
	public static extern inline final I = from(Key.I);
	public static extern inline final J = from(Key.J);
	public static extern inline final K = from(Key.K);
	public static extern inline final L = from(Key.L);
	public static extern inline final M = from(Key.M);
	public static extern inline final N = from(Key.N);
	public static extern inline final O = from(Key.O);
	public static extern inline final P = from(Key.P);
	public static extern inline final Q = from(Key.Q);
	public static extern inline final R = from(Key.R);
	public static extern inline final S = from(Key.S);
	public static extern inline final T = from(Key.T);
	public static extern inline final U = from(Key.U);
	public static extern inline final V = from(Key.V);
	public static extern inline final W = from(Key.W);
	public static extern inline final X = from(Key.X);
	public static extern inline final Y = from(Key.Y);
	public static extern inline final Z = from(Key.Z);

	public static extern inline final NUMPAD_0 = from(Key.NUMPAD_0);
	public static extern inline final NUMPAD_1 = from(Key.NUMPAD_1);
	public static extern inline final NUMPAD_2 = from(Key.NUMPAD_2);
	public static extern inline final NUMPAD_3 = from(Key.NUMPAD_3);
	public static extern inline final NUMPAD_4 = from(Key.NUMPAD_4);
	public static extern inline final NUMPAD_5 = from(Key.NUMPAD_5);
	public static extern inline final NUMPAD_6 = from(Key.NUMPAD_6);
	public static extern inline final NUMPAD_7 = from(Key.NUMPAD_7);
	public static extern inline final NUMPAD_8 = from(Key.NUMPAD_8);
	public static extern inline final NUMPAD_9 = from(Key.NUMPAD_9);

	public static extern inline final NUMPAD_ENTER = from(Key.NUMPAD_ENTER);
	public static extern inline final NUMPAD_DOT = from(Key.NUMPAD_DOT);
	public static extern inline final NUMPAD_PLUS = from(Key.NUMPAD_ADD);
	public static extern inline final NUMPAD_MINUS = from(Key.NUMPAD_SUB);
	public static extern inline final NUMPAD_ASTERISK = from(Key.NUMPAD_MULT);
	public static extern inline final NUMPAD_SLASH = from(Key.NUMPAD_DIV);

	/**
		Casts `code` to `KeyCode`.
	**/
	public static extern inline function from(code: Int): KeyCode
		return new KeyCode(code);

	/**
		The integer value of `this` keycode.
	**/
	public var code(get, never): Int;

	extern inline function new(code: Int)
		this = code;

	extern inline function get_code()
		return this;
}
#end
