package broker.input.heaps;

#if heaps
import sneaker.log.Logger.*;
import banker.vector.Vector;

/**
	Virtual multitap for managing multiple physical gamepads (i.e. `hxd.Pad` instances).
**/
class HeapsPadMultitap {
	/**
		Default length of `ports`.
	**/
	public static inline final defaultCapacity = 4;

	/**
		List of ports for connecting physical gamepads.
	**/
	public static var ports(default, null) = createPorts(defaultCapacity);

	/**
		Function called when a new physical gamepad is connected.
		Can be replaced with any custom function.
	**/
	public static var onConnect = function(pad: hxd.Pad, portIndex: Int) return;

	/**
		Function called when a new physical gamepad is disconnected.
		Can be replaced with any custom function.
	**/
	public static var onDisconnect = function(pad: hxd.Pad, portIndex: Int) return;

	/**
		Callback function for connecting a new physical gamepad to any available port.
	**/
	public static final connect = function(pad: hxd.Pad) {
		final index = ports.ref.findFirstIndex(portIsEmpty);
		if (index < 0) {
			debug('New gamepad recognized but the ports are already full.');
			return;
		}
		info('Gamepad connected. Port index: $index');

		ports[index].set(pad);
		onConnect(pad, index);

		pad.onDisconnect = function() {
			onDisconnect(pad, index);
			ports[index].set(HeapsPadTools.dummyPad);
			info('Gamepad disconnected. Port index: $index');
		}
	};

	/**
		@param capacity The number of ports (`ports.length`), i.e. the max number of
		  physical gamepads that can be managed by `HeapsPadMultitap`.
	**/
	public static function resetPorts(capacity: Int) {
		ports = createPorts(capacity);
	}

	static final portIsEmpty = (port: HeapsPadPort) -> port.get() == HeapsPadTools.dummyPad;

	static function createPorts(capacity: Int): Vector<HeapsPadPort> {
		return Vector.createPopulated(
			capacity,
			() -> HeapsPadPort.fromValue(HeapsPadTools.dummyPad)
		);
	}
}
#end
