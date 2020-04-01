package integration.actor;

/**
	AoSoA of `Player`.
**/
@:build(banker.aosoa.Aosoa.fromChunk(integration.actor.Player.PlayerChunk))
class PlayerAosoa implements ActorAosoa {}
