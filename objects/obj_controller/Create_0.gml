// 선택 상태
selection_done = false;

// The remaster board is procedural so its art always matches gameplay coordinates.
depth = 100;
if (layer_exists("board_layer")) layer_set_visible("board_layer", false);

// 턴/세대 시스템 변수
turn_system_started = false;
battle_ready = false;     // Start 버튼이 true로 만듦
balls = []

turn_index = 0;
generation = 1;
state = BattleState.IDLE;
turn_advanced_by_removal = false;

if(room = Room1){
	// 초기 스타팅 3개 생성
	var list = [1, 4, 7];
	var xlist = [680, 800, 920];
	var yy = 480;

	for (var i = 0; i < 3; i++) {
	    var inst = instance_create_layer(xlist[i], yy, "Instances", obj_ball);
	    inst.pokemon_id = list[i];
	    inst.owner = "none";
	}
}

alarm[0] = 1;
// Collision SFX uses an absolute timestamp instead of an alarm owned by a ball.
// This keeps the cooldown stable even when the ball is destroyed mid-collision.
global.next_collision_sound_time = 0;

// Bottom HUD volume control state. Draw and input share these exact values.
volume_bar_x = 1060;
volume_bar_width = 170;
volume_bar_height = 10;
volume_dragging = false;
set_master_volume(global.master_volume);
