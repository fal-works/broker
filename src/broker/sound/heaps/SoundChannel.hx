package broker.sound.heaps;

#if heaps
private typedef Data = hxd.snd.Channel;

/**
	A sound unit that is accually being played and can be stopped/paused individually.
**/
@:notNull
abstract SoundChannel(Data) from Data to Data {
	/**
		`this` as the underlying type.
	**/
	public var data(get, never): Data;

	/**
		Sets the volume of `this`.
	**/
	public extern inline function volume(v: Float): SoundChannel {
		this.volume = v;
		return this;
	}

	/**
		Stops `this` channel.
	**/
	public extern inline function stop(): Void
		this.stop();

	/**
		Pauses `this` channel.
	**/
	public extern inline function pause(): Void
		this.pause = true;

	/**
		Resumes pause of `this` channel.
	**/
	public extern inline function resume(): Void
		this.pause = false;

	/**
		Applies fade-in effect.
		@param duration Duration in seconds.
	**/
	public extern inline function fadeIn(duration: Float, ?onEnd: () -> Void): Void
		this.fadeTo(1.0, duration, onEnd); // TODO: stop on end?

	/**
		Applies fade-out effect.
		@param duration Duration in seconds.
	**/
	public extern inline function fadeOut(duration: Float, ?onEnd: () -> Void): Void
		this.fadeTo(0.0, duration, onEnd);

	extern inline function get_data()
		return this;
}
#end
