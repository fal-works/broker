package broker.image.heaps;

import broker.image.common.FrameTiles as FrameTilesBase;
import banker.vector.Vector;

class FrameTiles extends FrameTilesBase {
	public static function fromImage(image: hxd.res.Image, center = true): FrameTiles {
		var entire = image.toTile();
		final frames: Array<Tile> = [];

		if (FrameTilesBase.tileSizeRegexp.match(image.name)) {
			final pixels = Std.parseInt(FrameTilesBase.tileSizeRegexp.matched(1));
			if (pixels != null) {
				final tileSize: Float = pixels;
				var x = 0.0;
				var y = 0.0;
				while (y < entire.height) {
					while (x < entire.width) {
						var tile = entire.sub(x, y, tileSize, tileSize);
						if (center) tile = tile.center();
						frames.push(tile);
						x += tileSize;
					}
					x = 0.0;
					y += tileSize;
				}
			}
		}

		return new FrameTiles(entire, Vector.fromArrayCopy(frames));
	}
}
