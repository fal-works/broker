package integration;

class ActorArmy {
	public final agents: ActorGroup;
	public final bullets: ActorGroup;

	public function new(
		maxAgentCount: Int,
		agentBatch: h2d.SpriteBatch,
		maxBulletCount: Int,
		bulletBatch: h2d.SpriteBatch
	) {
		// TODO: optimize
		final fireCallback = (
			x,
			y,
			speed,
			direction
		) -> this.bullets.emit(x, y, speed, direction);

		this.agents = new ActorGroup(maxAgentCount, agentBatch, fireCallback);
		this.bullets = new ActorGroup(maxBulletCount, bulletBatch, fireCallback);
	}

	public function update() {
		this.agents.aosoa.moveByGamepad();
		this.bullets.aosoa.update();
	}

	public function synchronize() {
		this.agents.synchronize();
		this.bullets.synchronize();
	}

	public inline function newBullet(
		x: Float,
		y: Float,
		speed: Float,
		direction: Float
	): Void {
		this.bullets.aosoa.emit(x, y, speed, direction);
	}
}
