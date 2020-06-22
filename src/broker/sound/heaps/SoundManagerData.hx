package broker.sound.heaps;

#if heaps
/**
	Heaps implementation for `SoundManager`.
**/
@:access(hxd.snd.Manager)
class SoundManagerData {
	public static function getMasterVolume()
		return get().masterVolume;

	public static function setMasterVolume(v: Float)
		return get().masterVolume = v;

	public static function stopAll(): Void
		get().stopAll();

	public static function pauseAll(): Void {
		var channel = get().channels;
		while (channel != null) {
			final next = channel.next;
			if (!channel.loop) channel.pause = true;
			channel = next;
		}
	}

	public static function resumeAll(): Void {
		var channel = get().channels;
		while (channel != null) {
			final next = channel.next;
			if (!channel.loop) channel.pause = false;
			channel = next;
		}
	}

	public static function disposeAll(): Void
		get().dispose();

	static extern inline function get(): hxd.snd.Manager
		return hxd.snd.Manager.get();
}
#end
