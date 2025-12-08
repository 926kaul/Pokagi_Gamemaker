var player_count = 0;
var enemy_count = 0;

// 바둑판 영역
var left = 120;
var right = 840;
var top = 120;
var bottom = 840;

with (obj_ball) {
    if (x >= left && x <= right && y >= top && y <= bottom) {
        if (owner == "player") player_count++;
        if (owner == "enemy") {
			enemy_count++;
			placed = true;
		}
    }
}

if (player_count >= 1 && enemy_count >= 1) {
    with (obj_controller) battle_ready = true;
	with (obj_mypokemon){
		if(pokeball_opened){
			clear_pokeball_instances();
			pokeball_opened = false;
		}
	}
    instance_destroy();  // 버튼 삭제
} else {
    show_debug_message("Start failed: Need player and enemy on the board.");
}