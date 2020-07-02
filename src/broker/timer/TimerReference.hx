package broker.timer;

private typedef Data = banker.types.Reference<Maybe<Timer>>;

/**
	Optional reference to any `Timer` instance.

	Has `step()` method as well as `Timer`, but it also clears the reference automatically once the timer is completed.
**/
@:notNull
abstract TimerReference(Data) from Data {
	@:to public extern inline function get(): Maybe<Timer>
		return this.get();

	public extern inline function new(?timer: Timer)
		this = Maybe.from(timer);

	/**
		Sets `this` to `timer`.
	**/
	public extern inline function set(timer: Timer): Void
		this.set(Maybe.from(timer));

	/**
		Removes the timer from `this` reference.
	**/
	public extern inline function clear(): Void
		this.set(Maybe.none());

	/**
		Steps the timer (if exists) and automatically clears the reference if completed.
	**/
	public extern inline function step(): Void {
		final timer = get();
		if (timer.isSome()) if (timer.unwrap().step()) clear();
	}
}
