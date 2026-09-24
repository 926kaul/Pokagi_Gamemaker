var player_count = 0;
var enemy_count = 0;

// 바둑판 영역
var left = global.board.left;
var right = global.board.right;
var top = global.board.top;
var bottom = global.board.bottom;

with (obj_ball) {
    if (x >= left && x <= right && y >= top && y <= bottom) {
        if (team_is_player(owner)) player_count++;
        if (team_is_enemy(owner)) {
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
