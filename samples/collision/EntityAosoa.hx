package collision;

import broker.entity.BasicAosoa;
import banker.aosoa.ChunkEntityId;
import broker.collision.QuadtreeSpace;

@:structInit
@:build(banker.aosoa.Aosoa.fromChunk(collision.Entity.EntityChunk))
class EntityAosoa implements BasicAosoa {}
