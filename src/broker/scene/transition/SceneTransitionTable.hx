package broker.scene.transition;

class SceneTransitionTable {
	/**
		List of registered records.
	**/
	final records: Array<SceneTransitionRecord>;

	/**
		The transition that is returned from `findTransition()` if no specific record is found.
	**/
	final defaultTransition: SceneTransition;

	public function new(?defaultTransition: SceneTransition) {
		this.records = [];

		this.defaultTransition = if (defaultTransition != null) defaultTransition else {
			final transition: DirectSceneTransition = {
				delayDuration: UInt.one,
				destroy: true
			};
			transition;
		}
	}

	/**
		Adds `record` to `this` table.
		Throws error if any record with same keys is already registered.
	**/
	public function add(record: SceneTransitionRecord): Void {
		final records = this.records;
		final len = records.length;
		for (i in 0...len) {
			final record = records[i];
			if (record.hasSameKeys(record))
				throw "Duplicate keys.";
		}

		records.push(record);
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
		@return Corresponding transition for provided scene types.
	**/
	public function findTransition(
		precedingType: SceneTypeId,
		succeedingType: SceneTypeId
	): SceneTransition {
		final record = findRecord(precedingType, succeedingType);

		return if (record.isSome()) record.unwrap().transition else this.defaultTransition;
	}

	/**
		@return Record that matches provided scene types.
	**/
	public function findRecord(
		precedingType: SceneTypeId,
		succeedingType: SceneTypeId
	): Maybe<SceneTransitionRecord> {
		final records = this.records;
		final len = records.length;

		for (i in 0...len) {
			final record = records[i];
			if (record.precedingType == precedingType
				&& record.succeedingType == succeedingType) {
				return record;
			}
		}
		for (i in 0...len) {
			final record = records[i];
			if (record.precedingType == SceneTypeId.ALL
				&& record.succeedingType == succeedingType) {
				return record;
			}
		}
		for (i in 0...len) {
			final record = records[i];
			if (record.precedingType == precedingType
				&& record.succeedingType == SceneTypeId.ALL) {
				return record;
			}
		}
		for (i in 0...len) {
			final record = records[i];
			if (record.precedingType == SceneTypeId.ALL
				&& record.succeedingType == SceneTypeId.ALL) {
				return record;
			}
		}

		return Maybe.none();
	}
}
