package full;

import broker.collision.*;
import full.actor.Army;

class World {
	static inline final maxPlayerAgentCount = 1;
	static inline final maxPlayerBulletCount = 256;
	static inline final maxEnemyAgentCount = 64;
	static inline final maxEnemyBulletCount = 1024;

	final playerArmy: Army;
	final enemyArmy: Army;
	final offenceCollisionDetector: CollisionDetector;
	final offenctCollisionHandler: Collider -> Collider -> Void;

	public function new(scene: h2d.Scene) {
		playerArmy = WorldBuilder.createPlayerArmy(scene);
		enemyArmy = WorldBuilder.createEnemyArmy(scene);

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
	}

	function newEnemy(): Void {
		enemyArmy.newAgent(
			(0.1 + 0.8 * Math.random()) * Global.width,
			-32,
			1 + Math.random() * 1,
			0.5 * Math.PI
		);
	}
}

/**
	Functions internally used in `World.new()`.
**/
@:access(full.World)
private class WorldBuilder {
	public static function createPlayerArmy(scene: h2d.Scene): Army {
		final agentTile = h2d.Tile.fromColor(0xE0FFE0, 48, 48).center();
		final agentBatch = new h2d.SpriteBatch(agentTile, scene);

		final bulletTile = h2d.Tile.fromColor(0xE0FFE0, 16, 16).center();
		final bulletBatch = new h2d.SpriteBatch(bulletTile, scene);

		return new Army(Player(
			agentBatch,
			bulletBatch,
			World.maxPlayerBulletCount
		));
	}

	public static function createEnemyArmy(scene: h2d.Scene): Army {
		final agentTile = h2d.Tile.fromColor(0xD0D0FF, 48, 48).center();
		final agentBatch = new h2d.SpriteBatch(agentTile, scene);

		final bulletTile = h2d.Tile.fromColor(0xD0D0FF, 16, 16).center();
		final bulletBatch = new h2d.SpriteBatch(bulletTile, scene);

		return new Army(NonPlayer(
			agentBatch,
			bulletBatch,
			World.maxEnemyAgentCount,
			World.maxEnemyBulletCount
		));
	}
}
