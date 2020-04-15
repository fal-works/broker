package collision;

import banker.aosoa.ChunkEntityId;
import broker.entity.BasicAosoa;
import broker.collision.*;
import broker.collision.cell.*;

@:structInit
@:build(banker.aosoa.Aosoa.fromChunk(collision.Entity.EntityChunk))
class EntityAosoa implements BasicAosoa {}
