var _random_config = stage_get_random_enemy_config(room);
if (!is_undefined(_random_config)) {
    spawn_enemies_for_room(_random_config.ids, _random_config.count);
    battle_ready = false;
}
else if (room == RoomFinal){
	// 초기 스타팅 3개 생성
	var xlist = [600, 640, 800, 960, 1040];
	var ylist = [440, 280, 240, 280, 440] ;
	
	var list = [];
	switch(global.player_choice){
		case 1:	list = [130, 6, 18, 136, 103]; break;
		case 4: list = [103, 9, 18, 134, 59]; break;
		case 7: list = [59, 3, 18, 135, 130]; break;
		default: list = [3, 18, 6, 18, 9];
	}

	for (var i = 0; i < 5; i++) {
	    var inst = instance_create_layer(xlist[i], ylist[i], "Instances", obj_ball);
	    inst.pokemon_id = list[i];
	    inst.owner = "enemy";
		inst.placed = true;
	}
}
