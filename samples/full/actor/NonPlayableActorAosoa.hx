package full.actor;

/**
	AoSoA of `NonPlayableActor`.
**/
@:build(banker.aosoa.Aosoa.fromChunk(full.actor.NonPlayableActor.NonPlayableActorChunk))
@:banker_verified
class NonPlayableActorAosoa implements ActorAosoa {}
