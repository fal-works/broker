package broker.image.common;

import broker.image.FrameTiles;

class Atlas {
	final frameTilesMap: Map<String, FrameTiles>;

	public function new(frameTilesMap: Map<String, FrameTiles>) {
		this.frameTilesMap = frameTilesMap;
	}

	/**
		@return The `FrameTiles` instance of `name`.
	**/
	public function get(name: String): FrameTiles {
		final tiles = this.frameTilesMap.get(name);
		if (tiles == null) throw 'Image data not registered: $name';
		return tiles;
	}
}
