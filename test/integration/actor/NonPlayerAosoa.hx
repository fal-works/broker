package integration.actor;

/**
	AoSoA of `NonPlayer`.
**/
@:build(banker.aosoa.Aosoa.fromChunk(integration.actor.NonPlayer.NonPlayerChunk))
class NonPlayerAosoa implements ActorAosoa {}
