package broker.sound;

#if heaps
private typedef SoundData = broker.sound.heaps.SoundData;
#else
@:notNull
private abstract SoundData(Dynamic) {
	public extern inline function play(
		defaultVolume: Float,
		minInterval: Float,
		isLooped: Bool,
		preventsLayered: Bool
	): Maybe<SoundChannel> {
		return Maybe.none();
	}
}
#end

/**
	Sound data object.
**/
@:structInit
class Sound {
	/**
		Default volume of channels created by `this` sound.
	**/
	public final defaultVolume: Float;

	/**
		The minimum interval duration in seconds after the last play.
	**/
	public final minInterval: Float;

	/**
		If `true`, loops at the end.
	**/
	public final isLooped: Bool;

	/**
		If `true`, the last played channel is stopped when playing `this` sound again.
	**/
	public final preventsLayered: Bool;

	/**
		The internal data.
	**/
	final data: SoundData;

	public function new(
		data: SoundData,
		defaultVolume: Float = 1.0,
		minInterval: Float = 0.0,
		isLooped: Bool = false,
		preventsLayered: Bool = false
	) {
		this.data = data;
		this.defaultVolume = defaultVolume;
		this.minInterval = minInterval;
		this.isLooped = isLooped;
		this.preventsLayered = preventsLayered;
	}

	/**
		Plays `this` sound.
		No effect if the time elapsed from the last play is equal or less than `this.minInterval`.
		@return `SoundChannel` instance. `Maybe.none()` if not played.
	**/
	public function play(): Maybe<SoundChannel> {
		return this.data.play(
			this.defaultVolume,
			this.minInterval,
			this.isLooped,
			this.preventsLayered
		);
	}
}
