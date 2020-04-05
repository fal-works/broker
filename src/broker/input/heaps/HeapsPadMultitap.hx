package broker.input.heaps;

#if heaps
import sneaker.log.Logger.*;
import banker.vector.Vector;

class HeapsPadMultitap {
	public static var maxPortCount = 4;
	public static var ports(default, null) = createPorts(maxPortCount);

	public static var onConnect = function(pad: hxd.Pad, portIndex: Int) return;
	public static var onDisconnect = function(pad: hxd.Pad, portIndex: Int) return;

	static var nextPortIndex = 0;
	static final portIsEmpty = (port: HeapsPadPort) -> port.get() == HeapsPadTools.dummyPad;

	public static function resetPorts(maxCount: Int) {
		ports = createPorts(maxCount);
	}

	static function createPorts(maxCount: Int) {
		return Vector.createPopulated(
			maxCount,
			() -> HeapsPadPort.fromValue(HeapsPadTools.dummyPad)
		);
	}

	static final onNewPad = function(pad: hxd.Pad) {
		final index = ports.ref.findFirstIndex(portIsEmpty);
		if (index < 0) {
			debug('Gamepad connected but there is no available virtual port.');
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
}
#end
