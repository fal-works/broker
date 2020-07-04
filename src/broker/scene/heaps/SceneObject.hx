package broker.scene.heaps;

#if heaps
@:forward(x, y, setPosition)
abstract SceneObject(h2d.Object) from h2d.Object to h2d.Object {
	public static function fromImage(image: hxd.res.Image): SceneObject {
		return new h2d.Bitmap(image.toTile());
	}

	public extern inline function new() {
		this = new h2d.Object();
	}
}
#end
