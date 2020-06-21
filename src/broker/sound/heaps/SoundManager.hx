package broker.sound.heaps;

#if heaps
/**
	Static fields for managing all the sounds used in the program.
**/
@:access(hxd.snd.Manager)
class SoundManager {
	/**
		Master volume.
		No effect if the driver does not have master volume feature.
	**/
	public static var masterVolume(get, set): Float;

	/**
		Stops all sound channels.
	**/
	public static extern inline function stopAll(): Void
		get().stopAll();

	/**
		Pauses all sound channels.
	**/
	public static function pauseAll(): Void {
		var channel = get().channels;
		while (channel != null) {
			final next = channel.next;
			if (!channel.loop) channel.pause = true;
			channel = next;
		}
	}

	/**
		Resumes all sound channels paused.
	**/
	public static function resumeAll(): Void {
		var channel = get().channels;
		while (channel != null) {
			final next = channel.next;
			if (!channel.loop) channel.pause = false;
			channel = next;
		}
	}

	/**
		Disposes all sounds and sound channels.
	**/
	public static function disposeAll(): Void
		get().dispose();

	static extern inline function get(): hxd.snd.Manager
		return hxd.snd.Manager.get();

	static extern inline function get_masterVolume()
		return get().masterVolume;

	static extern inline function set_masterVolume(v: Float)
		return get().masterVolume = v;
}
#end
