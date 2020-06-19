package broker.sound.heaps;

#if heaps
@:notNull
abstract SoundData(hxd.res.Sound) from hxd.res.Sound {
	@:access(hxd.res.Sound)
	public extern inline function play(
		defaultVolume: Float,
		minInterval: Float,
		isLooped: Bool,
		preventsLayered: Bool
	): Maybe<broker.sound.SoundChannel> {
		final now = haxe.Timer.stamp();

		return if (now - this.lastPlay <= minInterval) Maybe.none() else {
			final lastChannel = this.channel;
			if (preventsLayered && lastChannel != null) lastChannel.stop();

			Maybe.from(this.play(isLooped, defaultVolume));
		}
	}
}
#end
