package broker.tools;

import sneaker.print.PrintBuffer;
import broker.timer.Timer;

using StringTools;
using sinker.Floats;

/**
	Features related to Garbage Collection.
**/
class Gc {
	static var logger: Maybe<GcLogger>;

	public static function startProfile(): Void
		profile(true);

	public static function stopProfile(): Void
		profile(false);

	/**
		@param flushIntervalDuration If `MaybeUInt.none`, this will be the same as `logIntervalDuration`.
	**/
	public static function startLogging(
		logIntervalDuration: UInt,
		flushIntervalDuration: MaybeUInt = MaybeUInt.none
	): Void {
		if (logger.isSome()) return;

		logger = new GcLogger(
			logIntervalDuration,
			flushIntervalDuration.or(logIntervalDuration)
		);
	}

	public static function stopLogging(): Void {
		if (logger.isNone()) return;

		logger.unwrap().forceFlush();
		logger = Maybe.none();
	}

	/**
		Updates GC logger. Automatically called by `broker.App` every frame.
	**/
	static function update(): Void
		logger.may(GcLogger.update);

	static function profile(on: Bool): Void {
		final gcFlags = hl.Gc.flags;
		final profileFlag = hl.Gc.GcFlag.Profile;
		if (on) gcFlags.set(profileFlag);
		else gcFlags.unset(profileFlag);
		hl.Gc.flags = gcFlags;
	}
}

private class GcLogger {
	public static final update = (logger: GcLogger) -> {
		logger.recorder.step();
		logger.flusher.step();
	}

	final buffer: LogBuffer;
	final recorder: LogRecordTimer;
	final flusher: LogFlushTimer;

	public function new(logIntervalDuration: UInt, flushIntervalDuration: UInt) {
		final buf = new LogBuffer();
		this.buffer = buf;
		this.recorder = new LogRecordTimer(buf, logIntervalDuration);
		this.flusher = new LogFlushTimer(buf, flushIntervalDuration);
	}

	public function forceFlush(): Void
		this.buffer.flush();
}

@:forward(flush)
private abstract LogBuffer(PrintBuffer) {
	/**
		Used for padding.
	**/
	static extern inline final allocationCountWidth = 10;

	/**
		Used for padding.
	**/
	static extern inline final totalAllocatedWidth = 12;

	public function new() {
		this = new PrintBuffer();
		log("allocCount", "size(kB)"); // header line
	}

	/**
		Adds values to `this` buffer with left-padding.
	**/
	public function log(allocationCount: String, totalAllocated: String): Void {
		final buf = this.current;
		// I'm not printing stats.currentMemory because I've no idea what this is
		buf.addLeftPadded(allocationCount, " ".code, allocationCountWidth);
		buf.addLeftPadded(totalAllocated, " ".code, totalAllocatedWidth);
		buf.lf();
	}
}

/**
	Base class for `LogRecordTimer` and `LogFlushTimer`.
**/
private class LogTimer extends Timer {
	final buffer: LogBuffer;

	public function new(buffer: LogBuffer, intervalDuration: UInt) {
		super();
		this.buffer = buffer;
		this.setDuration(intervalDuration);
	}

	override public function onComplete() {
		super.onComplete();
		this.progress = 0.0; // loop
	}
}

/**
	Timer that records GC logs regularly.
**/
@:access(broker.tools.Gc)
private class LogRecordTimer extends LogTimer {
	override public function onComplete() {
		super.onComplete();

		final stats = hl.Gc.stats();
		final count = stats.allocationCount;
		final size = (stats.totalAllocated / 1024.0).toInt();

		this.buffer.log(Std.string(count), Std.string(size));
	}
}

/**
	Timer that flushes GC logs regularly.
**/
private class LogFlushTimer extends LogTimer {
	override public function onComplete() {
		super.onComplete();
		this.buffer.flush();
	}
}
