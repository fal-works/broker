package full.actor;

import full.actor.Army.ArmyBuilder.*;

enum ArmyParameters {
	Player(
		agentBatch: h2d.SpriteBatch,
		bulletBatch: h2d.SpriteBatch,
		maxBulletCount: UInt
	);
	NonPlayer(
		agentBatch: h2d.SpriteBatch,
		bulletBatch: h2d.SpriteBatch,
		maxAgentCount: UInt,
		maxBulletCount: UInt
	);
}

class Army {
	public final agents: ActorAosoa;
	public final bullets: ActorAosoa;
	public final agentQuadtree: Quadtree;
	public final bulletQuadtree: Quadtree;
	public final onHitAgent: Collider -> Void;
	public final onHitBullet: Collider -> Void;

	public function new(parameters: ArmyParameters) {
		// TODO: optimize?
		final fireCallback = (
			x,
			y,
			speed,
			direction
		) -> this.bullets.emit(x, y, speed, direction);

		switch parameters {
			case Player(agentBatch, bulletBatch, maxBulletCount):
				final agentAosoa = createPlayableActors(
					agentBatch,
					fireCallback
				);
				this.agents = agentAosoa;
				this.onHitAgent = createOnHitPlayable(agentAosoa);

				final bulletAosoa = createNonPlayableActors(
					maxBulletCount,
					bulletBatch,
					fireCallback
				);
				this.bullets = bulletAosoa;
				this.onHitBullet = createOnHitNonPlayable(bulletAosoa);

			case NonPlayer(agentBatch, bulletBatch, maxAgentCount, maxBulletCount):
				final agentAosoa = createNonPlayableActors(
					maxAgentCount,
					agentBatch,
					fireCallback
				);
				this.agents = agentAosoa;
				this.onHitAgent = createOnHitNonPlayable(agentAosoa);

				final bulletAosoa = createNonPlayableActors(
					maxBulletCount,
					bulletBatch,
					fireCallback
				);
				this.bullets = bulletAosoa;
				this.onHitBullet = createOnHitNonPlayable(bulletAosoa);
		}

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

/**
	Functions internally used in `Army.new()`.
**/
class ArmyBuilder {
	static var defaultChunkCapacity: UInt = 64;

	public static function createPlayableActors(
		batch: h2d.SpriteBatch,
		fireCallback: FireCallback
	): PlayableActorAosoa {
		final tile = batch.tile;
		final spriteFactory = () -> new h2d.SpriteBatch.BatchElement(tile);
		return new PlayableActorAosoa(
			1,
			1,
			batch,
			spriteFactory,
			tile.width / 2,
			tile.height / 2,
			fireCallback
		);
	}

	public static function createOnHitPlayable(aosoa: PlayableActorAosoa) {
		return (collider: Collider) -> {
			final id = ChunkEntityId.fromInt(collider.id);
			final chunk = aosoa.getChunk(id);
			final index = chunk.getReadIndex(id);
			// chunk.dead[index] = true;
		};
	}

	public static function createNonPlayableActors(
		maxEntityCount: UInt,
		batch: h2d.SpriteBatch,
		fireCallback: FireCallback
	): NonPlayableActorAosoa {
		final chunkCapacity = UInts.min(defaultChunkCapacity, maxEntityCount);
		final chunkCount = Math.ceil(maxEntityCount / chunkCapacity);

		final tile = batch.tile;
		final spriteFactory = () -> new h2d.SpriteBatch.BatchElement(tile);
		return new NonPlayableActorAosoa(
			chunkCapacity,
			chunkCount,
			batch,
			spriteFactory,
			tile.width / 2,
			tile.height / 2,
			fireCallback
		);
	}

	public static function createOnHitNonPlayable(aosoa: NonPlayableActorAosoa) {
		return (collider: Collider) -> {
			final id = ChunkEntityId.fromInt(collider.id);
			final chunk = aosoa.getChunk(id);
			final index = chunk.getReadIndex(id);
			chunk.dead[index] = true;
			@:privateAccess chunk.deadChunkBuffer[index] = true;
		};
	}
}
