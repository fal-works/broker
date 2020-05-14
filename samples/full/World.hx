package full;

import full.actor.Army.PlayableArmy;
import banker.types.Reference;
import broker.geometry.MutableAabb;
import broker.collision.*;
import broker.scene.Layer;
import full.actor.*;

class World {
	static inline final maxPlayerAgentCount: UInt = 1;
	static inline final maxPlayerBulletCount: UInt = 256;
	static inline final maxEnemyAgentCount: UInt = 64;
	static inline final maxEnemyBulletCount: UInt = 1024;
	static inline final playerAgentHalfCollisionSize = 16.0;

	final playerArmy: PlayableArmy;
	final enemyArmy: Army;
	final offenceCollisionDetector: CollisionDetector;
	final offenctCollisionHandler: Collider -> Collider -> Void;

	final playerAabb: MutableAabb = new MutableAabb();
	final foundDefenceCollision: Reference<Bool> = false;

	public function new(parent: h2d.Object) {
		playerArmy = WorldBuilder.createPlayerArmy(parent);
		enemyArmy = WorldBuilder.createEnemyArmy(parent);

		offenceCollisionDetector = CollisionDetector.createInterGroup(
			Space.partitionLevel,
			{
				left: {
					maxColliderCount: maxPlayerBulletCount,
					quadtree: playerArmy.bulletQuadtree
				},
				right: {
					maxColliderCount: maxEnemyAgentCount,
					quadtree: enemyArmy.agentQuadtree
				}
			}
		);
		offenctCollisionHandler = (playerBulletCollider, enemyAgentCollider) -> {
			playerArmy.onHitBullet(playerBulletCollider);
			enemyArmy.onHitAgent(enemyAgentCollider);
		};

		playerArmy.newAgent(0.5 * Global.width, 0.75 * Global.height, 0, 0);
	}

	public function update(): Void {
		playerArmy.update();
		enemyArmy.update();

		if (Math.random() < 0.03) newEnemy();

		playerArmy.synchronize();
		enemyArmy.synchronize();

		playerArmy.reloadQuadtrees();
		enemyArmy.reloadQuadtrees();

		offenceCollisionDetector.detect(offenctCollisionHandler);

		if (playerHasCollided()) {
			enemyArmy.bullets.crashAll();
			enemyArmy.bullets.synchronize();
			playerArmy.playerAosoa.damage();
		}
	}

	function newEnemy(): Void {
		enemyArmy.newAgent(
			(0.1 + 0.8 * Math.random()) * Global.width,
			-32,
			1 + Math.random() * 1,
			0.5 * Math.PI
		);
	}

	function updatePlayerAabb(): Void {
		final playerPosition = Global.playerPosition;
		playerArmy.playerAosoa.assignPosition(playerPosition);
		playerAabb.set(
			playerPosition.x() - playerAgentHalfCollisionSize,
			playerPosition.y() - playerAgentHalfCollisionSize,
			playerPosition.x() + playerAgentHalfCollisionSize,
			playerPosition.y() + playerAgentHalfCollisionSize
		);
	}

	function playerHasCollided(): Bool {
		updatePlayerAabb();

		foundDefenceCollision.set(false);
		enemyArmy.bullets.findOverlapped(
			playerAabb,
			foundDefenceCollision
		);

		return foundDefenceCollision.get();
	}
}

/**
	Functions internally used in `World.new()`.
**/
@:access(full.World)
private class WorldBuilder {
	public static function createPlayerArmy(parent: h2d.Object) {
		final agentTile = h2d.Tile.fromColor(0xE0FFE0, 48, 48).center();
		final agentBatch = new h2d.SpriteBatch(agentTile, parent);

		final bulletTile = h2d.Tile.fromColor(0xE0FFE0, 16, 16).center();
		final bulletBatch = new h2d.SpriteBatch(bulletTile, parent);

		final bullets = ArmyBuilder.createNonPlayableActors(World.maxPlayerBulletCount, bulletBatch);
		final onHitBullet = ArmyBuilder.createOnHitNonPlayable(bullets);

		final agents = ArmyBuilder.createPlayableActors(agentBatch, bullets);
		final onHitAgent = ArmyBuilder.createOnHitPlayable(agents);

		return new Army.PlayableArmy(agents, onHitAgent, bullets, onHitBullet);
	}

	public static function createEnemyArmy(parent: h2d.Object) {
		final agentTile = h2d.Tile.fromColor(0xD0D0FF, 48, 48).center();
		final agentBatch = new h2d.SpriteBatch(agentTile, parent);

		final bulletTile = h2d.Tile.fromColor(0xD0D0FF, 16, 16).center();
		final bulletBatch = new h2d.SpriteBatch(bulletTile, parent);

		final bullets = ArmyBuilder.createNonPlayableActors(World.maxEnemyBulletCount, bulletBatch);
		final onHitBullet = ArmyBuilder.createOnHitNonPlayable(bullets);

		final agents = ArmyBuilder.createNonPlayableActors(World.maxEnemyAgentCount, agentBatch, bullets);
		final onHitAgent = ArmyBuilder.createOnHitNonPlayable(agents);

		return new Army.NonPlayableArmy(agents, onHitAgent, bullets, onHitBullet);
	}
}
