package broker.image.common;

import haxe.ds.StringMap;
import broker.image.FrameTiles; // do not use broker.image.common.FrameTiles

class Atlas {
	final frameTilesMap: StringMap<FrameTiles>;

	public function new(frameTilesMap: StringMap<FrameTiles>) {
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
