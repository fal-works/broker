package broker.tools;

#if sys
import haxe.Timer;
import sys.io.File;
import sneaker.string_buffer.StringBufferBox;
#end

/**
	Static utility class for naive performance profiling.
**/
class PerformanceProfiler {
	#if sys
	public static var logFilePath(default, null) = "fps_log.csv";
	static var log: Maybe<StringBufferBox> = Maybe.none();
	static var lastStamp: Float = 0.0;
	static var updateTime: Float = 0.0;
	static var renderTime: Float = 0.0;
	static extern inline final errorThresholdFactor = 2.0;
	#else
	public static extern inline final logFilePath = "";
	#end

	/**
		Starts profiling.
		@param append `true` to append the result to the log file if it already exists.
		Otherwise removes the last output.
	**/
	public static function start(append = false): Void {
		#if sys
		if (log.isNone()) {
			final flush: (logString: String) -> Void = if (append) {
				logString -> {
					final out = File.append(logFilePath);
					out.writeString(logString);
					out.close();
				}
			} else {
				logString -> File.saveContent(logFilePath, logString);
			};

			final bufferBox = new StringBufferBox(flush);
			bufferBox.buffer.addLf('frame count, update (ms), render (ms) ${Date.now().toString()}');
			log = bufferBox;
		}
		#end
	}

	/**
		Stops profiling and outputs the result to the log file.
		This will also be automatically called when `Window` is closed.
	**/
	public static function stop(): Void {
		#if sys
		if (log.isSome()) {
			final logBox = log.unwrap();
			logBox.buffer.lf();
			logBox.flush();
			log = Maybe.none();
		}
		#end
	}

	/**
		Sets the log file name.
	**/
	public static function setLogFileName(fileName: String): Void {
		#if sys
		if (0 < fileName.length) {
			if (fileName.getIndexOfDot().isNone()) fileName += ".csv";
			logFilePath = fileName;
		}
		#end
	}

	/**
		Automatically called before the updating process in the main loop.
	**/
	static inline function preUpdate(): Void {
		#if sys
		if (log.isSome()) lastStamp = Timer.stamp();
		#end
	}

	/**
		Automatically called after the updating process in the main loop.
	**/
	static inline function postUpdate(frameCount: UInt): Void {
		#if sys
		if (log.isSome()) {
			final now = Timer.stamp();
			updateTime = 1000.0 * (now - lastStamp);
		}
		#end
	}

	/**
		Automatically called after the rendering process in the main loop.
	**/
	static inline function postRender(): Void {
		#if sys
		if (log.isSome()) {
			final now = Timer.stamp();
			renderTime = 1000.0 * (now - lastStamp);
		}
		#end
	}

	/**
		Automatically called at the end of each frame.
	**/
	static inline function writeLog(frameCount: UInt): Void {
		#if sys
		if (log.isSome()) {
			final thresholdTime = errorThresholdFactor * 1000.0 / getIdealFps();
			if (updateTime < thresholdTime && renderTime < thresholdTime) {
				log.unwrap().buffer.addLf('$frameCount, $updateTime, $renderTime');
			}
		}
		#end
	}

	/**
		@return The ideal FPS.
	**/
	static inline function getIdealFps(): Float {
		#if heaps
		return hxd.Timer.wantedFPS;
		#else
		return 60.0;
		#end
	}
}
