package broker.sound;

/**
	Static fields for managing all the sounds used in the program.
**/
#if heaps
typedef SoundManager = broker.sound.heaps.SoundManager;
#else
class SoundManager {
	public static var masterVolume(get, set): Float;

	public static function update(): Void {}

	public static function enqueue(sound: Sound): Void {}

	public static extern inline function stopAll(): Void {}

	public static extern inline function pauseAll(): Void {}

	public static extern inline function resumeAll(): Void {}

	static extern inline function get_masterVolume()
		return 1.0;

	static extern inline function set_masterVolume(v: Float)
		return 1.0;
}
#end
