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
		this.agents = ActorGroup.create(
			this,
			maxAgentCount,
			agentBatch
		);
		this.bullets = ActorGroup.create(
			this,
			maxBulletCount,
			bulletBatch
		);
	}

	public function update() {
		this.agents.aosoa.moveByGamepad();
		this.bullets.aosoa.update();
	}

	public function synchronize() {
		this.agents.synchronize();
		this.bullets.synchronize();
	}
}
