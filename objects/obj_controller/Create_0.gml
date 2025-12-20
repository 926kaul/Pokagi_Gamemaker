// 선택 상태
selection_done = false;

// 턴/세대 시스템 변수
turn_system_started = false;
battle_ready = false;     // Start 버튼이 true로 만듦
balls = []

turn_index = 0;
generation = 1;
state = "idle";   // "idle" → 아직 게임 시작 전

if(room = Room1){
	// 초기 스타팅 3개 생성
	var list = [1, 4, 7];
	var xlist = [360, 480, 600];
	var yy = 480;

	for (var i = 0; i < 3; i++) {
	    var inst = instance_create_layer(xlist[i], yy, "Instances", obj_ball);
	    inst.pokemon_id = list[i];
	    inst.owner = "none";
	}
}

alarm[0] = 1;
set_master_volume(global.master_volume*0.5);
global.sound_cooldown = false;