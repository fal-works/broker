package broker.scene.transition;

class SceneTransitionTable {
	final records: Array<SceneTransition>;
	final defaultTransition: SceneTransition;

	public function new(?defaultTransition: SceneTransition) {
		this.records = [];

		this.defaultTransition = if (defaultTransition != null) defaultTransition else {
			final transition: DirectSceneTransition = {
				precedingSceneType: SceneTypeId.ALL,
				succeedingSceneType: SceneTypeId.ALL,
				delayDuration: UInt.zero,
				destroy: true
			};
			transition;
		}
	}

	/**
		Adds `transition` to `this` graph.
		Throws error if any transition with same keys is already registered.
	**/
	public function add(transition: SceneTransition): Void {
		final records = this.records;
		final len = records.length;
		for (i in 0...len) {
			final record = records[i];
			if (record.hasSameKeys(transition))
				throw "Duplicate keys.";
		}

		records.push(transition);
	}

	/**
		Finds and runs the corresponding transition from `currentScene` to `nextScene`.
	**/
	public function runTransition(currentScene: Scene, nextScene: Scene): Void {
		final transition = this.findTransition(
			currentScene.getTypeId(),
			nextScene.getTypeId()
		);
		transition.run(currentScene, nextScene);
	}

	/**
		Finds the corresponding transition from `currentScene` to `nextScene`.
	**/
	public function findTransition(
		precedingSceneType: SceneTypeId,
		succeedingSceneType: SceneTypeId
	): SceneTransition {
		final records = this.records;
		final len = records.length;

		for (i in 0...len) {
			final record = records[i];
			if (record.precedingSceneType == precedingSceneType
				&& record.succeedingSceneType == succeedingSceneType) {
				return record;
			}
		}
		for (i in 0...len) {
			final record = records[i];
			if (record.precedingSceneType == SceneTypeId.ALL
				&& record.succeedingSceneType == succeedingSceneType) {
				return record;
			}
		}
		for (i in 0...len) {
			final record = records[i];
			if (record.precedingSceneType == precedingSceneType
				&& record.succeedingSceneType == SceneTypeId.ALL) {
				return record;
			}
		}

		return this.defaultTransition;
	}
}
