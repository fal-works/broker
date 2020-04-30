package full.actor;

class Army {
	public final agents: ActorAosoa;
	public final bullets: ActorAosoa;
	public final onHitAgent: Collider->Void;
	public final onHitBullet: Collider->Void;
	public final agentQuadtree: Quadtree;
	public final bulletQuadtree: Quadtree;

	public function new(
		agents: ActorAosoa,
		onHitAgent: Collider->Void,
		bullets: ActorAosoa,
		onHitBullet: Collider->Void
	) {
		this.agents = agents;
		this.onHitAgent = onHitAgent;

		this.bullets = bullets;
		this.onHitBullet = onHitBullet;

		this.agentQuadtree = new Quadtree(Space.partitionLevel);
		this.bulletQuadtree = new Quadtree(Space.partitionLevel);
	}

	public function update() {
		this.agents.update();
		this.bullets.update();
	}

	public function synchronize() {
		this.agents.synchronize();
		this.bullets.synchronize();
	}

	public function reloadQuadtrees() {
		this.agentQuadtree.reset();
		this.agents.loadQuadTree(this.agentQuadtree);

		this.bulletQuadtree.reset();
		this.bullets.loadQuadTree(this.bulletQuadtree);
	}

	public inline function newAgent(
		x: Float,
		y: Float,
		speed: Float,
		direction: Float
	): Void {
		this.agents.emit(x, y, speed, direction);
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

class PlayableArmy extends Army {
	public final playerAosoa: PlayableActorAosoa;

	public function new(
		agents: PlayableActorAosoa,
		onHitAgent: Collider->Void,
		bullets: ActorAosoa,
		onHitBullet: Collider->Void
	) {
		super(agents, onHitAgent, bullets, onHitBullet);
		this.playerAosoa = agents;
	}
}

class NonPlayableArmy extends Army {
	public final enemyAgents: NonPlayableActorAosoa;

	public function new(
		agents: NonPlayableActorAosoa,
		onHitAgent: Collider->Void,
		bullets: ActorAosoa,
		onHitBullet: Collider->Void
	) {
		super(agents, onHitAgent, bullets, onHitBullet);
		this.enemyAgents = agents;
	}

	override public function update(): Void {
		super.update();
		this.enemyAgents.mayFire();
	}
}
