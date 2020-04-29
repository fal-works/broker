package full.actor;

import broker.entity.BasicAosoa;

interface ActorAosoa extends BasicAosoa {
	function update(): Void;
	function loadQuadTree(quadtree: Quadtree): Void;
}
