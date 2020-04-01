package integration.actor;

import broker.entity.heaps.BasicEntity;

class Actor extends BasicEntity {
	@:banker_chunkLevelFinal
	var fire: FireCallback;
}
