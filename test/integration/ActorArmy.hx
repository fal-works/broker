package integration;

import broker.entity.heaps.EntityGroup;

class ActorArmy {
	public final agents: EntityGroup<ActorAosoa>;
	public final bullets: EntityGroup<ActorAosoa>;

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

		final agentAosoa: ActorAosoa = ActorAosoaBuilder.create(
			maxAgentCount,
			agentBatch,
			fireCallback
		);
		this.agents = new EntityGroup(agentAosoa, agentBatch.tile);

		final bulletAosoa: ActorAosoa = ActorAosoaBuilder.create(
			maxBulletCount,
			bulletBatch,
			fireCallback
		);
		this.bullets = new EntityGroup(bulletAosoa, bulletBatch.tile);
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
