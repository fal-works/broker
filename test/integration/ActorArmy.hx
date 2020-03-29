package integration;

class ActorArmy {
	public final player: h2d.Object;
	public final bullets = Actor.createAosoa(64, 32);

	public function new(?parent: h2d.Object) {
		player = new h2d.Bitmap(hxd.Res.player.toTile(), parent);
		player.x = 100;
		player.y = 100;
	}

	public function update() {
		bullets.update();
	}

	@:access(h2d.SpriteBatch)
	public function synchronize() {
		bullets.synchronize();
		bullets.updateSprite();
	}
}
