package broker.object.heaps;

/**
	Static extension for `Object`.
**/
class ObjectExtension {
	/**
		Sets `filter` to `this` object.
	**/
	public static extern inline function setFilter(object: Object, filter: Filter): Void
		object.data.filter = filter;
}
