package integration.actor;

class ActorGroup extends broker.entity.BasicEntityGroup<ActorAosoa> {
	public function update()
		this.aosoa.update();
}
