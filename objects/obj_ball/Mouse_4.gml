if (!obj_controller. turn_system_started
    && owner == "player"
    && !placed) 
{
    is_placing = true;
	original_x = x;
	original_y = y;
}



if (obj_controller.turn_system_started
    && current_turn
    && placed
    && !moving && owner == "player")
{
    is_shooting = true;
    pull_start_x = x;       // 공의 위치
    pull_start_y = y;
}

