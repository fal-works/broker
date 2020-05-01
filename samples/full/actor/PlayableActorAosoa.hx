package full.actor;

/**
	AoSoA of `PlayableActor`.
**/
@:build(banker.aosoa.Aosoa.fromChunk(full.actor.PlayableActor.PlayableActorChunk))
@:banker_verified
class PlayableActorAosoa implements ActorAosoa {}
