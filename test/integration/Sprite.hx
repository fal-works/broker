package integration;

import h2d.SpriteBatch.BatchElement;

class Sprite extends BatchElement {
	static var nextId = 0;

	public final id: Int;

	public function new(t) {
		super(t);
		this.id = nextId++;
	}

	public inline function kill(): Void {
		batch.delete(this);
	}
}
