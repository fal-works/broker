package full.actor;

/**
	AoSoA of `NonPlayableActor`.
**/
@:build(banker.aosoa.Aosoa.fromChunk(full.actor.NonPlayableActor.NonPlayableActorChunk))
class NonPlayableActorAosoa implements ActorAosoa {}
