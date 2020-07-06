package broker.scene.heaps;

#if heaps
import broker.scene.internal.SceneObjectData;

@:forward(x, y, setPosition, addChild, removeChild, removeChildren)
abstract SceneObject(SceneObjectData) from SceneObjectData to SceneObjectData {
	/**
		Creates a `SceneObject` from `image` bitmap.
	**/
	public static function fromImage(image: hxd.res.Image): SceneObject {
		return new h2d.Bitmap(image.toTile());
	}

	/**
		`this` as the underlying type.
	**/
	public var data(get, never): SceneObjectData;

	public extern inline function new() {
		this = new SceneObjectData();
	}

	/**
		Sets `filter` to `this` object.
	**/
	public extern inline function setFilter(filter: Filter): Void
		this.filter = filter;

	extern inline function get_data()
		return this;
}
#end
