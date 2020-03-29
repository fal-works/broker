package integration;

import h2d.SpriteBatch;

class ActorRenderer {
	public static var tile(default, null): h2d.Tile;
	public static var batch(default, null): SpriteBatch;

	public static function initialize(?parent: h2d.Object) {
		tile = hxd.Res.player_bullet.toTile();
		batch = new SpriteBatch(tile, parent);
	}

	public function new() {
	}
}
