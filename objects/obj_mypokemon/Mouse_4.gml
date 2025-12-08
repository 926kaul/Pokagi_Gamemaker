pokeball_opened = !pokeball_opened;

if (pokeball_opened && !obj_controller.battle_ready) {
    self.create_pokeball_instances();   
} else {
	self.clear_pokeball_instances();
}