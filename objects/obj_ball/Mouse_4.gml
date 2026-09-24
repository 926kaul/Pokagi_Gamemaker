if (!obj_controller.turn_system_started
    && !obj_controller.battle_ready
    && team_is_player(owner)
    && !placed) 
{
    is_placing = true;
	if (!has_collection_home) {
		original_x = x;
		original_y = y;
	}
}



if (obj_controller.turn_system_started
    && current_turn
    && placed
    && !moving && team_is_player(owner))
{
    is_shooting = true;
    pull_start_x = x;       // 공의 위치
    pull_start_y = y;
}

