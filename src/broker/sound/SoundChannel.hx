package broker.sound;

/**
	A sound unit that is accually being played and can be stopped/paused individually.
**/
#if heaps
typedef SoundChannel = broker.sound.heaps.SoundChannel;
#else
@:notNull
abstract SoundChannel(Dynamic) from Dynamic to Dynamic {
	public var data(get, never): Data;

	public extern inline function volume(v: Float): SoundChannel
		return this;

	public extern inline function stop(): Void {}
	public extern inline function pause(): Void {}
	public extern inline function resume(): Void {}
	public extern inline function fadeIn(duration: Float, ?onEnd: () -> Void): Void {}
	public extern inline function fadeOut(duration: Float, ?onEnd: () -> Void): Void {}

	extern inline function get_data()
		return this;
}
#end
