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
**/
@:structInit
class Sound {
	/**
		Empty function used as a default value for `this.onPlay()`.
	**/
	static final emptyOnPlay = (sound: Sound, channel: SoundChannel) -> {};

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
		At default `play()` has no effect if `this` is not playable.
		However if `this.maxQueueCount` is greater than zero, the playback is delayed (instead of being ignored)
		until a sufficient number of frames (i.e. `this.minInterval`) have passed,
		unless the queue count reaches `maxQueueCount`.

		Be sure to call `SoundManager.update()` every frame if you set `maxQueueCount` to any non-zero value.
	**/
	public final maxQueueCount: UInt;

	/**
		If `true`, the last played channel is not stopped when playing `this` sound again.
	**/
	public final allowsLayered: Bool;

	/**
		Function called every time `this` is played.
	**/
	public final onPlay: (sound: Sound, channel: SoundChannel) -> Void;

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
	public final data: SoundData;

	public function new(
		data: SoundData,
		defaultVolume: Float = 1.0,
		minInterval: UInt = UInt.one,
		isLooped: Bool = false,
		maxQueueCount: UInt = UInt.zero,
		allowsLayered: Bool = false,
		?onPlay: (sound: Sound, channel: SoundChannel) -> Void
	) {
		this.data = data;

		this.defaultVolume = defaultVolume;
		this.minInterval = minInterval;
		this.isLooped = isLooped;
		this.maxQueueCount = maxQueueCount;
		this.allowsLayered = allowsLayered;
		this.onPlay = Nulls.coalesce(onPlay, emptyOnPlay);

		this.lastPlayedChannel = Maybe.none();
		this.lastPlayedFrameCount = UInt.zero;
	}

	/**
		Plays `this` sound.
		@return `SoundChannel` instance. `Maybe.none()` if not immediately played.
	**/
	public function play(): Maybe<SoundChannel> {
		final currentFrameCount = SoundManager.frameCount;

		final lastChannel = this.lastPlayedChannel;
		if (lastChannel.isSome()) {
			if (currentFrameCount - this.lastPlayedFrameCount < this.minInterval) {
				SoundManager.enqueue(this);
				return Maybe.none();
			}

			if (!this.allowsLayered)
				lastChannel.unwrap().stop();
		}

		final newChannel = this.data.play(this.defaultVolume, this.isLooped);
		this.onPlay(this, newChannel);

		this.lastPlayedChannel = Maybe.from(newChannel);
		this.lastPlayedFrameCount = currentFrameCount;

		return newChannel;
	}
}
