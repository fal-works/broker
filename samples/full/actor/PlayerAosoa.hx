package full.actor;

/**
	AoSoA of `Player`.
**/
@:build(banker.aosoa.Aosoa.fromChunk(full.actor.Player.PlayerChunk))
class PlayerAosoa implements ActorAosoa {}
