package broker.sound.heaps;

#if heaps
import banker.map.ArrayMap;

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
		Total frame count elapsed. Incremented in `update()`.
	**/
	public static var frameCount(default, null): UInt = UInt.zero;

	/**
		Mapping from `Sound` instance to its queue count.
		@see `Sound.maxQueueCount`
		@see `SoundManager.updateQueues()`
	**/
	static var queuedSounds = new ArrayMap<Sound, UInt>(UInt.one);

	/**
		Callback function used in `update()`.
		Plays `sound` only if a sufficient number of frames have passed since the last play.
		If played, decrements `queueCount` and re-assigns the value to `queuedSounds`.
		@return `true` if `queueCount` is decreased to zero.
	**/
	static final updateQueues = function(sound: Sound, queueCount: UInt): Bool {
		if (frameCount - sound.lastPlayedFrameCount < sound.minInterval) return false;
		sound.play();
		--queueCount; // argument queueCount should be always greater than zero
		queuedSounds.set(sound, queueCount);
		return queueCount.isZero();
	};

	/**
		Updates `SoundManager`.
		Call this method every frame if you use `Sound` class.
	**/
	public static function update(): Void {
		queuedSounds.removeAll(updateQueues); // Remove if queue count is decreased to zero.
		++frameCount;
	}

	/**
		Enqueues `sound` for a delayed play unless the queue for `sound` is full.
	**/
	public static function enqueue(sound: Sound): Void {
		final maxQueueCount = sound.maxQueueCount;
		if (maxQueueCount.isZero()) return;

		var queuedSounds = SoundManager.queuedSounds;

		if (queuedSounds.hasKey(sound)) {
			final nextQueueCount = queuedSounds.get(sound).plusOne();
			if (nextQueueCount <= maxQueueCount)
				queuedSounds.set(sound, nextQueueCount);
		} else {
			if (queuedSounds.size == queuedSounds.capacity)
				SoundManager.queuedSounds = queuedSounds = new ArrayMap(queuedSounds.capacity * 2);

			queuedSounds.set(sound, UInt.one);
		}
	}

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
