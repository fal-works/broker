package broker.sound.heaps;

#if heaps
@:notNull
abstract SoundData(hxd.res.Sound) from hxd.res.Sound {
	public extern inline function play(
		defaultVolume: Float,
		isLooped: Bool
	): broker.sound.SoundChannel {
		return this.play(isLooped, defaultVolume);
	}
}
#end
