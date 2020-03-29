package integration;

class ActorGroup {
	public static function create(chunkCapacity: Int, chunkCount: Int) {
		ActorGroup.chunkCapacity = chunkCapacity;
		ActorGroup.chunkCount = chunkCount;

		return new ActorGroup();
	}

	static var chunkCapacity = 0;
	static var chunkCount = 0;

	final aosoa = Actor.createAosoa(chunkCapacity, chunkCount);

	private function new() {
	}
}
