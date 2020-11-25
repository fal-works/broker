package broker.draw.heaps;

import banker.vector.VectorReference;
import broker.object.Object;

/**
	Object that draws multiple elements efficiently.
	The tiles should be created from to the same texture.
**/
@:notNull
@:forward(clear)
abstract BatchDraw(h2d.SpriteBatch) from h2d.SpriteBatch to h2d.SpriteBatch to Object {
	/**
		@param texture Tiles added to `this` batch should be made from this texture.
		@param width The rendering area width. No effect `#if heaps` (Use `DrawArea` for clipping).
		@param height The rendering area height. No effect `#if heaps` (Use `DrawArea` for clipping).
		@param hasRotationScale `true` (default) to enable rotation and scaling.
		@param smooth `true` to enable smoothing.
	**/
	public extern inline function new(
		texture: Texture,
		width: UInt,
		height: UInt,
		hasRotationScale = true,
		?smooth: Bool
	) {
		this = new h2d.SpriteBatch(texture.getEntireTile());
		this.hasRotationScale = hasRotationScale;
		if (smooth != null) this.smooth = smooth;
	}

	public extern inline function asObject(): Object
		return this;

	/**
		@return `true` if any sprite is added to `this`.
	**/
	public extern inline function hasAnySprite(): Bool
		return @:privateAccess this.first != null;

	public extern inline function add(sprite: BatchSprite): Void {
		// skip (before == true) instead of this.add(sprite, false);
		final e = sprite.data;
		@:privateAccess @:nullSafety(Off) {
			e.batch = this;
			if (this.first == null) {
				this.first = e;
				this.last = e;
				e.prev = null;
				e.next = null;
			} else {
				final last = this.last;
				last.next = e;
				e.prev = last;
				e.next = null;
				this.last = e;
			}
		}
	}

	@:access(h2d.SpriteBatch)
	public extern inline function remove(sprite: BatchSprite): Void {
		this.delete(sprite); // sprite must belong to this batch
	}

	/**
		Adds elements of `sprites` (from index `0` until but not including `endIndex`) to `this` batch.
	**/
	public function addSprites(
		sprites: VectorReference<BatchSprite>,
		endIndex: UInt
	): Void {
		var i = UInt.zero;
		while (i < endIndex) {
			add(sprites[i]);
			++i;
		}
	}

	/**
		Removes elements of `sprites` (from index `0` until but not including `endIndex`) from `this` batch.
	**/
	public function removeSprites(
		sprites: VectorReference<BatchSprite>,
		endIndex: UInt
	): Void {
		var i = UInt.zero;
		while (i < endIndex) {
			remove(sprites[i]);
			++i;
		}
	}
}
