package broker.scene;

import sneaker.assertion.Asserter.assert;
import sneaker.tag.Tagged;

/**
	Base class for stack of `Scene` instances.
	This only updates the top scene in `update()` method.
**/
#if !broker_generic_disable
@:generic
#end
class SceneStack<T: Layer> extends Tagged {
	/**
		The internal array of `Scene` instances.
	**/
	final scenes: Array<Scene<T>>;

	/**
		Creates a new stack instance with an `initialScene`.
		This does not activate `initialScene` automatically.
	**/
	public function new(initialScene: Scene<T>, capacity: UInt) {
		super();
		this.scenes = [initialScene];
	}

	/**
		Pushes `scene` to `this` stack.
	**/
	public function push(scene: Scene<T>): Void {
		final scenes = this.scenes;
		scenes.peek().deactivate();
		scenes.push(scene);
		scene.activate();
	}

	/**
		@return The top/newest scene of `this` stack.
	**/
	public function peek(): Scene<T>
		return this.scenes.peek();

	/**
		Swaps the top/newest two scenes of `this` stack.
	**/
	public function swap(): Void {
		final scenes = this.scenes;
		final length = scenes.length;
		assert(length > 1, this.tag, "Not enough elements.");

		final topIndex = scenes.length.minusOne().unwrap();
		final topScene = scenes[topIndex];
		topScene.deactivate();

		final secondTopIndex = topIndex.minusOne().unwrap();
		final secondTopScene = scenes[secondTopIndex];
		secondTopScene.activate();

		scenes[secondTopIndex] = topScene;
		scenes[topIndex] = secondTopScene;
	}

	/**
		Removes and returns the top/newest scene of `this` stack.
		Be sure to check that `this` has at least 2 scenes before calling this method.
		@param destroy If `true`, calls `destroy()` on the popped scene.
	**/
	public function pop(destroy = true): Scene<T> {
		final scenes = this.scenes;
		assert(scenes.length > 1, this.tag, "SceneStack cannot be empty.");

		final popped = scenes.pop().unwrap();
		if (destroy) popped.destroy(); else popped.deactivate();

		scenes.peek().activate();

		return popped;
	}

	/**
		Pops the current top/newest scene and then pushes `newScene` to `this`.
		@param destroy If `true`, calls `destroy()` on the popped scene.
	**/
	public function switchTop(newScene: Scene<T>, destroy = true): Void {
		final popped = this.scenes.pop().unwrap();
		if (destroy) popped.destroy(); else popped.deactivate();

		this.push(newScene);
	}

	/**
		Updates the top/newest scene of `this` stack.
	**/
	public function update(): Void
		this.peek().update();

	/**
		Removes and destroys all scenes in `this` stack and resets the stack with `bottomScene`.
		@param bottomScene If not provided, preserves the existing bottom scene without destroying it.
	**/
	public function reset(?bottomScene: Scene<T>): Void {
		final scenes = this.scenes;
		var index = scenes.length.minusOne().unwrap();
		while (index > UInt.zero) {
			scenes[index].destroy();
			--index;
		}
		scenes.resize(UInt.one);

		if (bottomScene != null) {
			scenes[UInt.zero].destroy();
			scenes[UInt.zero] = bottomScene;
			bottomScene.activate();
		}
	}
}
