package broker.sound;

import banker.map.ArrayMap;
import broker.timer.Timer;
import broker.timer.Timer.TimerExtension;
import broker.timer.TimerReference;

#if heaps
private typedef SoundManagerData = broker.sound.heaps.SoundManagerData;
#else
private class SoundManagerData {
	public static function getMasterVolume()
		return 0.0;

	public static function setMasterVolume(v: Float)
		return v;

	public static function stopAll(): Void {}

	public static function pauseAll(): Void {}

	public static function resumeAll(): Void {}

	public static function disposeAll(): Void {}
}
#end

/**
	Static fields for managing all the sounds used in the program.
**/
class SoundManager {
	/**
		Master volume.
		No effect if the driver does not have master volume feature.
	**/
	public static var masterVolume(get, set): Float;

	/**
		The value to which `masterVolume` should be set if `resetMasterVolume()` is called.
		No effect if the driver does not have master volume feature.
	**/
	public static var defaultMasterVolume(default, set): Float = 1.0;

	/**
		Total frame count elapsed. Incremented in `update()`.
	**/
	public static var frameCount(default, null): UInt = UInt.zero;

	/**
		Timer that is currently running for changing `masterVolume`.
	**/
	static var masterVolumeChangeTimer = new TimerReference();

	/**
		Timer instance for `masterVolumeChangeTimer`. Reused every time `changeMasterVolume()` is called.
	**/
	static var masterVolumeChangeTimerInstance = new MasterVolumeTimer();

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
		Sets `masterVolume` to `defaultMasterVolume`.
	**/
	public static function resetMasterVolume(): Void
		masterVolume = defaultMasterVolume;

	/**
		Starts to change `masterVolume` gradually.
		@param startVolume If not provided, starts with the current value of `masterVolume`.
	**/
	public static function changeMasterVolume(
		duration: UInt,
		endVolume: Float,
		startVolume: Float = -1.0
	): Void {
		masterVolumeChangeTimer.set(masterVolumeChangeTimerInstance.reset(
			duration,
			if (startVolume < 0.0) masterVolume else startVolume,
			endVolume
		));
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
		SoundManagerData.stopAll();

	/**
		Pauses all sound channels.
	**/
	public static extern inline function pauseAll(): Void
		SoundManagerData.pauseAll();

	/**
		Resumes all sound channels paused.
	**/
	public static extern inline function resumeAll(): Void
		SoundManagerData.resumeAll();

	/**
		Disposes all sounds and sound channels.
	**/
	public static extern inline function disposeAll(): Void
		SoundManagerData.disposeAll();

	/**
		Updates `SoundManager` (automatically called by `broker.App` every frame).
	**/
	static function update(): Void {
		masterVolumeChangeTimer.step();
		queuedSounds.removeAll(updateQueues); // Remove if queue count is decreased to zero.
		++frameCount;
	}

	static extern inline function get_masterVolume()
		return SoundManagerData.getMasterVolume();

	static extern inline function set_masterVolume(v: Float)
		return SoundManagerData.setMasterVolume(v);

	static extern inline function set_defaultMasterVolume(v: Float)
		return masterVolume = defaultMasterVolume = v;
}

/**
	Timer for changing `SoundManager.masterVolume`.
**/
private class MasterVolumeTimer extends Timer {
	var startVolume: Float = 0.0;
	var volumeChange: Float = 0.0;

	public function new()
		super();

	/**
		@param start If negative, starts with the current value of `SoundManager.masterVolume`.
	**/
	public function reset(
		duration: UInt,
		start: Float,
		end: Float
	): MasterVolumeTimer {
		TimerExtension.reset(this, duration);

		final startVolume = if (start < 0.0) SoundManager.masterVolume else start;
		this.startVolume = startVolume;
		this.volumeChange = end - startVolume;

		return this;
	}

	override public function onProgress(progress: Float): Void {
		SoundManager.masterVolume = this.startVolume + progress * this.volumeChange;
	}
}
