package integration;

import broker.entity.heaps.BasicEntityInitializer;
import integration.Actor.ActorInitializer;

class ActorAosoaBuilder {
	/**
		Creates an `ActorAosoa` instance.
		Use this instead of `new()`.
	**/
	public static function create(
		constructor: () -> ActorAosoa,
		batch: h2d.SpriteBatch,
		fireCallback: FireCallback
	): ActorAosoa {
		BasicEntityInitializer.batch = batch;
		ActorInitializer.fire = fireCallback;

		final aosoa = constructor();

		@:nullSafety(Off) {
			BasicEntityInitializer.batch = cast null;
			ActorInitializer.fire = cast null;
		}

		return aosoa;
	}
}
