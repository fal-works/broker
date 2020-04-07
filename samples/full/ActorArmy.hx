package full;

import full.actor.*;

class ActorArmy {
	public final agents: ActorAosoa;
	public final bullets: ActorAosoa;

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

		final agentAosoa: PlayerAosoa = ActorAosoaBuilder.create(
			maxAgentCount,
			agentBatch,
			fireCallback
		);
		this.agents = agentAosoa;

		final bulletAosoa: NonPlayerAosoa = ActorAosoaBuilder.create(
			maxBulletCount,
			bulletBatch,
			fireCallback
		);
		this.bullets = bulletAosoa;
	}

	public function update() {
		this.agents.update();
		this.bullets.update();
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
		this.bullets.emit(x, y, speed, direction);
	}
}
