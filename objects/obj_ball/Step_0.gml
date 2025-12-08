image_index = pokemon_id-1;
stats = global.poke_stats[pokemon_id];
if(placed){
	image_xscale = stats.size/1.5;
	image_yscale = stats.size/1.5;
}

if (is_placing) {
    x = mouse_x;
    y = mouse_y;
}

if (moving) {
    x += velocity_x;
    y += velocity_y;

	var friction_coefficient = 0.95;
	if(obj_controller.generation > 5) friction_coefficient = 0.98;
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
if ((x < 120 || x > 840 || y < 120 || y > 840) && placed)
{
    is_dead = true;
	if(owner == "enemy"){
		obj_mypokemon.my_pokes[pokemon_id-1] = 1;
		if(pokemon_id == 150) obj_mypokemon.my_pokes[131] = 1;
		save_my_pokes();
	}
}
