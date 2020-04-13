package broker.collision;

class QuadtreeSpaceTools {
	/**
		Separates each bit of `n` with one unset bit.
		@param n Any bit array (max 16 bits)
	**/
	public static inline function separateBits(n: Int): Int {
		n = (n | (n << 8)) & 0x00ff00ff; // 0000 0000 1111 1111 0000 0000 1111 1111
		n = (n | (n << 4)) & 0x0f0f0f0f; // 0000 1111 0000 1111 0000 1111 0000 1111
		n = (n | (n << 2)) & 0x33333333; // 0011 0011 0011 0011 0011 0011 0011 0011
		n = (n | (n << 1)) & 0x55555555; // 0101 0101 0101 0101 0101 0101 0101 0101
		return n;
	}

	/**
		Zips two bit arrays.
		@param a Any bit array (max 16 bits)
		@param b Any bit array (max 16 bits)
	**/
	public static inline function zipBits(a: Int, b: Int): Int {
		return separateBits(a) | (separateBits(b) << 1);
	}
}
