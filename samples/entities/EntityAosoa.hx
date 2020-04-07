package entities;

import broker.entity.BasicAosoa;

@:build(banker.aosoa.Aosoa.fromChunk(entities.Entity.EntityChunk))
class EntityAosoa implements BasicAosoa {}
