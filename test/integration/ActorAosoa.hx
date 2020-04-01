package integration;

import broker.entity.heaps.BasicAosoa;

/**
	AoSoA of `Actor`.
**/
@:build(banker.aosoa.Aosoa.fromChunk(integration.Actor.ActorChunk))
class ActorAosoa implements BasicAosoa {}
