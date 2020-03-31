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
		this.agents = new ActorGroup(this, maxAgentCount, agentBatch);
		this.bullets = new ActorGroup(this, maxBulletCount, bulletBatch);
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
