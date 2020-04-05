package broker.input.heaps;

#if heaps
import banker.vector.Vector;
import banker.vector.VectorReference;
import sneaker.log.Logger.*;

class HeapsPadTools {
	public static final dummyPad = hxd.Pad.createDummy();
	public static var maxSocketCount = 4;
	public static var sockets(default, null) = createSockets(maxSocketCount);

	public static var onConnect = function(pad: hxd.Pad, socketIndex: Int) return;
	public static var onDisconnect = function(pad: hxd.Pad, socketIndex: Int) return;

	static var nextSocketIndex = 0;
	static final socketIsEmpty = (socket: HeapsPadSocket) -> socket.get() == dummyPad;

	public static function initialize() {
		hxd.Pad.wait(onNewPad);
	}

	public static function resetSockets(maxCount: Int) {
		sockets = createSockets(maxCount);
	}

	/**
		@return `true` if any button in `buttonCodes` is down.
	**/
	public static function anyButtonIsDown(socket: HeapsPadSocket, buttonCodes: VectorReference<Int>): Bool {
		final buttons = socket.get().buttons;
		for (i in 0...buttonCodes.length) {
			if (buttons[buttonCodes[i]]) return true;
		}
		return false;
	}

	/**
		@return Function that returns `true` if any button of `buttonCodeArray` is down.
	**/
	public static inline function createButtonCodesChecker<T>(
		socket: HeapsPadSocket,
		buttonCodeArray: Array<Int>
	): () -> Bool {
		final buttonCodes = Vector.fromArrayCopy(buttonCodeArray);
		return anyButtonIsDown.bind(socket, buttonCodes);
	};

	static function createSockets(maxCount: Int) {
		return Vector.createPopulated(
			maxCount,
			() -> HeapsPadSocket.fromValue(dummyPad)
		);
	}

	static final onNewPad = function(pad: hxd.Pad) {
		final index = sockets.ref.findFirstIndex(socketIsEmpty);
		if (index < 0) {
			debug('Gamepad connected but there is no available virtual socket.');
			return;
		}
		info('Gamepad connected. Socket index: $index');

		sockets[index].set(pad);
		onConnect(pad, index);

		pad.onDisconnect = function() {
			onDisconnect(pad, index);
			sockets[index].set(dummyPad);
			info('Gamepad disconnected. Socket index: $index');
		}
	};
}
#end
