image_index = pokemon_id-1;
stats = global.poke_stats[pokemon_id];

// Room-authored enemies already occupy the arena before START. Previously
// only procedurally spawned enemies were marked as placed immediately, so
// fixed-room enemies kept the default scale until the button was pressed.
if (!placed && team_is_enemy(owner) && board_is_inside(x, y)) {
	placed = true;
}

if(placed){
	image_xscale = base_image_scale * stats.size;
	image_yscale = base_image_scale * stats.size;
}

if (is_placing) {
    x = mouse_x;
    y = mouse_y;
}

if (moving) {
    x += velocity_x;
    y += velocity_y;

	var friction_coefficient = 0.95;
	if (obj_controller.generation >= obj_controller.low_friction_round) friction_coefficient = 0.98;
    velocity_x *= friction_coefficient;
    velocity_y *= friction_coefficient;

    if (abs(velocity_x) < 0.1 && abs(velocity_y) < 0.1) {
        moving = false;
		velocity_x = 0;
		velocity_y = 0;
    }
}



// 최근 위치 기록
array_push(trail, [x, y]);

// trail 길이 제한
if (array_length(trail) > trail_length) {
    array_delete(trail, 0, 1); // 제일 오래된 좌표 제거
}


// -------------------------------
// (C) 바둑판 밖 → 즉시 사망
// -------------------------------
// -------------------------------
// 바둑판 밖 → 즉시 사망
// -------------------------------
if (!board_is_inside(x, y) && placed)
{
    is_dead = true;
	if(team_is_enemy(owner)){
		profile_catch(pokemon_id);
		if(pokemon_id == 150) profile_catch(132);
	}
}
