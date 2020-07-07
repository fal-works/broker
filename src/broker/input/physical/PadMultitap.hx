package broker.input.physical;

import sneaker.log.Logger.*;
import banker.vector.Vector;

/**
	Virtual multitap for managing multiple `Pad` instances.
**/
class PadMultitap {
	/**
		Default length of `ports`.
	**/
	public static inline final defaultCapacity: UInt = 8;

	/**
		List of ports for connecting physical gamepads.
	**/
	public static var ports(default, null) = createPorts(defaultCapacity);

	/**
		Function called when a new physical gamepad is connected.
		Can be replaced with any custom function.
	**/
	public static var onConnect = (pad: Pad, portIndex: UInt) -> return;

	/**
		Function called when a new physical gamepad is disconnected.
		Can be replaced with any custom function.
	**/
	public static var onDisconnect = (pad: Pad, portIndex: UInt) -> return;

	/**
		Callback function for connecting a new physical gamepad to any available port.
	**/
	public static final connect = function(pad: Pad) {
		final maybeIndex = ports.ref.findFirstIndex(portIsEmpty);
		if (maybeIndex.isNone()) {
			debug('New gamepad recognized but the ports are already full.');
			return;
		}
		final index = maybeIndex.unwrap();
		info('Gamepad connected. Port index: $index');
		ports[index].set(pad);
		onConnect(pad, index);
		pad.setOnDisconnect(() -> {
			onDisconnect(pad, index);
			ports[index].set(Pad.NULL);
			info('Gamepad disconnected. Port index: $index');
		});
	};

	/**
		@param capacity The number of ports (`ports.length`), i.e. the max number of
			physical gamepads that can be managed by `PadMultitap`.
	**/
	public static function resetPorts(capacity: UInt) {
		ports = createPorts(capacity);
	}

	static final portIsEmpty = (port: PadPort) -> {
		return port.get() == Pad.NULL;
	}

	static function createPorts(capacity: UInt): Vector<PadPort> {
		return Vector.createPopulated(
			capacity,
			() -> new PadPort(Pad.NULL)
		);
	}
}
