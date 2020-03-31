package integration;

import broker.entity.heaps.BasicAosoa;

/**
	AoSoA of `Actor`.
**/
@:build(banker.aosoa.macro.Builder.aosoaFromChunk(integration.Actor.ActorChunk))
class ActorAosoa implements BasicAosoa {}
