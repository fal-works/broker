package broker.sound;

#if heaps
private typedef SoundData = broker.sound.heaps.SoundData;
#else
@:notNull
private abstract SoundData(Dynamic) {
	public extern inline function play(
		defaultVolume: Float,
		isLooped: Bool
	): SoundChannel {
		return null;
	}
}
#end

/**
	Sound data object.
	Be sure to call `Global.tick()` every frame if you use this class.
**/
@:structInit
class Sound {
	/**
		Default volume of channels created by `this` sound.
	**/
	public final defaultVolume: Float;

	/**
		The minimum interval frame count after the last play.
	**/
	public final minInterval: UInt;

	/**
		If `true`, loops at the end.
	**/
	public final isLooped: Bool;

	/**
		If `true`, the last played channel is stopped when playing `this` sound again.
	**/
	public final preventsLayered: Bool;

	/**
		Sound channel used at the time `this` was last played.
	**/
	public var lastPlayedChannel: Maybe<SoundChannel>;

	/**
		The value of `Sound.frameCount` at the time `this` was last played.
	**/
	public var lastPlayedFrameCount: UInt;

	/**
		The internal data.
	**/
	final data: SoundData;

	public function new(
		data: SoundData,
		defaultVolume: Float = 1.0,
		minInterval: UInt = UInt.one,
		isLooped: Bool = false,
		preventsLayered: Bool = false
	) {
		this.data = data;
		this.defaultVolume = defaultVolume;
		this.minInterval = minInterval;
		this.isLooped = isLooped;
		this.preventsLayered = preventsLayered;
		this.lastPlayedChannel = Maybe.none();
		this.lastPlayedFrameCount = UInt.zero;
	}

	/**
		Plays `this` sound.
		No effect if the time elapsed from the last play is equal or less than `this.minInterval`.
		@return `SoundChannel` instance. `Maybe.none()` if not played.
	**/
	public function play(): Maybe<SoundChannel> {
		final currentFrameCount = Global.frameCount;

		final lastChannel = this.lastPlayedChannel;
		if (lastChannel.isSome()) {
			if (currentFrameCount - this.lastPlayedFrameCount < this.minInterval)
				return Maybe.none();

			if (this.preventsLayered)
				lastChannel.unwrap().stop();
		}

		final newChannel = Maybe.from(this.data.play(this.defaultVolume, this.isLooped));

		this.lastPlayedChannel = newChannel;
		this.lastPlayedFrameCount = currentFrameCount;

		return newChannel;
	}
}
