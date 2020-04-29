package full.actor;

/**
	AoSoA of `PlayableActor`.
**/
@:build(banker.aosoa.Aosoa.fromChunk(full.actor.PlayableActor.PlayableActorChunk))
class PlayableActorAosoa implements ActorAosoa {}
