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
// Counts every player Pokemon deployed in this stage, including the initial
// setup. Knocked-out Pokemon do not refund a slot.
player_deployments_used = 0;
low_friction_round = 6;
state = BattleState.IDLE;
turn_advanced_by_removal = false;

// Low-friction guidance is tracked per battle. A new battle must show the
// round 6 warning again even when it starts in the same game session.
low_friction_tutorial_seen = false;
low_friction_tutorial_active = false;
low_friction_tutorial_open_guard = false;
low_friction_tutorial_text = "라운드 6부터 마찰력이 감소합니다.\n포켓몬의 이동이 오래 이어지니 세기와 각도를 조절하세요.";

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

// Apply the persisted value once the audio group is ready.
set_master_volume(global.master_volume);
