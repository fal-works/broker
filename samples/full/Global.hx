package full;

import broker.input.heaps.HeapsPadMultitap;
import broker.geometry.MutablePoint;
import broker.math.Random;
import full.gamepad.GamepadBuilder;
import full.particle.ParticleAosoa;

class Global {
	public static final defaultGamepadBuilder: GamepadBuilder = {
		keyCodeMap: [
			A => [hxd.Key.Z],
			B => [hxd.Key.X],
			X => [hxd.Key.SHIFT],
			Y => [hxd.Key.ESCAPE],
			D_LEFT => [hxd.Key.LEFT],
			D_UP => [hxd.Key.UP],
			D_RIGHT => [hxd.Key.RIGHT],
			D_DOWN => [hxd.Key.DOWN]
		],
		padButtonCodeMap: [
			A => [hxd.Pad.DEFAULT_CONFIG.A],
			B => [hxd.Pad.DEFAULT_CONFIG.B],
			X => [hxd.Pad.DEFAULT_CONFIG.X],
			Y => [hxd.Pad.DEFAULT_CONFIG.Y],
			D_LEFT => [hxd.Pad.DEFAULT_CONFIG.dpadLeft],
			D_UP => [hxd.Pad.DEFAULT_CONFIG.dpadUp],
			D_RIGHT => [hxd.Pad.DEFAULT_CONFIG.dpadRight],
			D_DOWN => [hxd.Pad.DEFAULT_CONFIG.dpadDown]
		],
		heapsPadPort: HeapsPadMultitap.ports[0],
		analogStickThreshold: 0.1,
		speedChangeButton: X,
		defaultSpeed: 9,
		alternativeSpeed: 3
	};

	public static inline final width: UInt = 800;
	public static inline final height: UInt = 600;

	public static var gamepad(default, null) = defaultGamepadBuilder.build();

	public static final playerPosition = new MutablePoint();

	public static var particles(default, null): ParticleAosoa;

	public static function initialize(s2d: h2d.Scene): Void {
		initializeParticles(s2d);
	}

	public static function update(): Void {
		gamepad.update();

		particles.update();
		particles.synchronize();
	}

	public static function emitParticles(
		x: Float,
		y: Float,
		minSpeed: Float,
		maxSpeed: Float,
		count: UInt
	): Void {
		var i = UInt.zero;
		while (i < count) {
			particles.emit(x, y, Random.between(minSpeed, maxSpeed), Random.angle());
			++i;
		}
	}

	static function initializeParticles(scene: h2d.Scene): Void {
		final tile = h2d.Tile.fromColor(0xFFFFFF, 12, 12).center();
		final batch = new h2d.SpriteBatch(tile, scene);
		batch.hasRotationScale = true;
		final spriteFactory = () -> new h2d.SpriteBatch.BatchElement(tile);
		particles = new ParticleAosoa(128, 24, batch, spriteFactory);
	}
}

class HabitableZone {
	static extern inline final margin: Float = 64;
	public static extern inline final leftX: Float = 0 - margin;
	public static extern inline final topY: Float = 0 - margin;
	public static extern inline final rightX: Float = 800 + margin;
	public static extern inline final bottomY: Float = 600 + margin;

	public static extern inline function containsPoint(x: Float, y: Float): Bool
		return y < bottomY && topY <= y && leftX <= x && x < rightX;
}
