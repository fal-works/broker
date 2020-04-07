package full.actor;

/**
	AoSoA of `NonPlayer`.
**/
@:build(banker.aosoa.Aosoa.fromChunk(full.actor.NonPlayer.NonPlayerChunk))
class NonPlayerAosoa implements ActorAosoa {}
