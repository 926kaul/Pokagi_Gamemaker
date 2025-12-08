if (room == Room2_1) {
    
    // 소환할 포켓몬 ID 목록 및 마릿수만 전달
    var _target_ids = [10, 13, 16, 19, 21, 23];
    var _count = 2; 

    spawn_enemies_for_room(_target_ids, _count);
	battle_ready = false;
}
else if (room == Room3_1) {
    
    // 소환할 포켓몬 ID 목록 및 마릿수만 전달
    var _target_ids = [29, 32, 35, 37, 39 ,41, 43, 46, 48];
    var _count = 3; 

    spawn_enemies_for_room(_target_ids, _count);
	battle_ready = false;
}
else if (room == Room4_1) {
    
    // 소환할 포켓몬 ID 목록 및 마릿수만 전달
    var _target_ids = [50, 52, 56, 58, 60 ,63, 66, 69, 72];
    var _count = 3; 

    spawn_enemies_for_room(_target_ids, _count);
	battle_ready = false;
}
else if (room == Room6_1) {
    
    // 소환할 포켓몬 ID 목록 및 마릿수만 전달
    var _target_ids = [77, 79, 83, 84, 86, 90 ,92, 96, 98];
    var _count = 3; 

    spawn_enemies_for_room(_target_ids, _count);
	battle_ready = false;
}
else if (room == Room7_1) {
    
    // 소환할 포켓몬 ID 목록 및 마릿수만 전달
    var _target_ids = [102, 104, 106, 107, 108, 111, 113, 115, 116];
    var _count = 3; 

    spawn_enemies_for_room(_target_ids, _count);
	battle_ready = false;
}
else if (room == Room8_1) {
    
    // 소환할 포켓몬 ID 목록 및 마릿수만 전달
    var _target_ids = [118, 120, 123, 124, 125, 127, 128, 129, 131];
    var _count = 3; 

    spawn_enemies_for_room(_target_ids, _count);
	battle_ready = false;
}
else if (room == Room8_2) {
    
    // 소환할 포켓몬 ID 목록 및 마릿수만 전달
    var _target_ids = [137, 138, 140, 142, 143];
    var _count = 3; 

    spawn_enemies_for_room(_target_ids, _count);
	battle_ready = false;
}
else if (room == RoomFinal){
	// 초기 스타팅 3개 생성
	var xlist = [280, 320, 480, 640, 720];
	var ylist = [440, 280, 240, 280, 440] ;
	
	var list = [];
	switch(global.player_choice){
		case 1:	list = [130, 6, 18, 136, 103]; break;
		case 4: list = [103, 9, 18, 134, 59]; break;
		case 7: list = [59, 3, 18, 135, 130]; break;
	}

	for (var i = 0; i < 5; i++) {
	    var inst = instance_create_layer(xlist[i], ylist[i], "Instances", obj_ball);
	    inst.pokemon_id = list[i];
	    inst.owner = "enemy";
		inst.placed = true;
	}
}