//-----------------------------------------------------
// 1) 선택 끝 처리 (player/ enemy/ 삭제)
//-----------------------------------------------------
// Starter icons use a consistent circular hit area. Precise sprite masks vary
// after the remaster artwork swap and should not decide which starter is usable.
if (room == Room1 && instance_exists(obj_tutorial1)
    && !selection_done && mouse_check_button_pressed(mb_left)) {
    var _choice = noone;
    var _choice_distance = 1000000;

    with (obj_ball) {
        if (owner == "none" || owner == Team.NONE) {
            var _distance = point_distance(x, y, mouse_x, mouse_y);
            if (_distance <= 34 && _distance < _choice_distance) {
                _choice_distance = _distance;
                _choice = id;
            }
        }
    }

    if (instance_exists(_choice)) {
        _choice.owner = "player";
        global.player_choice = _choice.pokemon_id;
        selection_done = true;
    }
}

if (selection_done) {

    var p = global.player_choice;
    var enemy_id;

    switch (p) {
        case 1: enemy_id = 7; break;
        case 4: enemy_id = 1; break;
        case 7: enemy_id = 4; break;
    }
	
	var _all_caught = true;
	for (var i = 0; i < 150; i++) { 
	    // 현재 요소의 값이 1이 아니라면
	    if (obj_mypokemon.my_pokes[i] != 1) {
	        // 플래그를 false로 설정하고 루프를 즉시 종료합니다.
	        _all_caught = false;
	        break; 
	    }
	}

    // player를 오른쪽 대기 위치로 이동
    with (obj_ball) {
		// The collection can be inspected during the starter tutorial. Do not
		// mistake its temporary grid icons for the selected starter.
        if (team_is_player(owner) && !has_collection_home) {
			profile_catch(p);
			instance_destroy();
        }
    }

	// If the collection was open while the starter was selected, rebuild it
	// so the newly caught partner appears immediately.
	with (obj_mypokemon) {
		if (pokeball_opened) {
			clear_pokeball_instances();
			create_pokeball_instances();
		}
	}

    // enemy 자동 배치
    with (obj_ball) {
        if (pokemon_id == enemy_id) {
            owner = "enemy";
			x = global.board.center_x;
			y = global.board.top + (global.board.grid_size * 3);
			placed = true;
			
			//뮤로 변신
			if(_all_caught){
				pokemon_id = 151;
			}
        }
    }

    // 나머지 삭제
    with (obj_ball) {
        if (owner == "none" || owner == Team.NONE) {
            instance_destroy();
        }
    }
	
	instance_destroy(obj_tutorial1);
    selection_done = false;
}


//-----------------------------------------------------
// 2) Start 버튼 클릭으로 battle_ready=true 됨
//    → 실제 턴 시스템 시작
//-----------------------------------------------------
if (!turn_system_started && battle_ready) {
    battle_start(id);
}

//-----------------------------------------------------
// 3) 전투 시작 이후의 턴/세대 시스템
//-----------------------------------------------------

switch (state) {

    case BattleState.WAIT_TURN:
		show_debug_message("wait_turn" + string(turn_index));
        var current = balls[turn_index];

        with (current) {
            current_turn = true;
        }

        state = BattleState.PLAYER_INPUT;
        break;
	
	case BattleState.PLAYER_INPUT:
		// show_debug_message("player_input" + string(turn_index));
	    current = balls[turn_index];
	    if (team_is_enemy(current.owner)) {
	        state = BattleState.ENEMY_ACTION;
	    }
	    break;
	
	case BattleState.ENEMY_ACTION:
		show_debug_message("enemy_act" + string(turn_index));
	    current = balls[turn_index];

	    enemy_take_action(current);
	    state = BattleState.MOVING;
	    break;
	
	case BattleState.MOVING:
	    var all_stopped = true;
	    for (var i = 0; i < array_length(balls); i++) {
	        var b = balls[i];

	        if (instance_exists(b)) {
	            if (b.moving) {
	                all_stopped = false;
	                break;
	            }
	        }
	    }
	    if (all_stopped)
			state = BattleState.END_TURN;
		break;

    case BattleState.END_TURN:
		show_debug_message("end_turn" + string(turn_index));
		// 현재 턴의 공이 장외로 제거되었다면 배열은 이미 다음 공을 가리킵니다.
		if (!turn_advanced_by_removal) {
			var next_ball = balls[turn_index];
			if (instance_exists(next_ball)) {
				with (next_ball) current_turn = false;
			}
			turn_index += 1;
		} else {
			turn_advanced_by_removal = false;
		}
		
		if (turn_index >= array_length(balls)) {
            generation += 1;
			
	        // 중심 거리 정렬
	        array_sort(balls, function(a, b) {
	            return board_distance_from_center(b) - board_distance_from_center(a);
	        });

	        turn_index = 0;
        }
		state = BattleState.WAIT_TURN;
		break;
	
	case BattleState.PLAYER_WIN:
		battle_process_victory(id);
		break;
}


/// 4) 죽은 공 수집 및 제거
for (var i = array_length(balls) - 1; i >= 0; i--) {
    var b = balls[i];

    // b가 이미 죽었거나 배열에 죽었다고 표시된 경우
    if (!instance_exists(b) || b.is_dead) {
		
		if (instance_exists(b)) {
            with (b) instance_destroy();
        }
		
		// 배열에서 제거
        array_delete(balls, i, 1);

		// 현재 턴의 공이 제거돼도 나머지 공들의 이동이 끝날 때까지 기다립니다.
		// 배열 삭제로 다음 공이 같은 인덱스로 이동했으므로 end_turn에서 증가시키지 않습니다.
		if (turn_index == i && state == BattleState.MOVING) {
			turn_advanced_by_removal = true;
		}

        // turn_index 조정
        if (turn_index > i) turn_index -= 1;
    }
}

/// 5) 승패 판정
var player_alive = false;
var enemy_alive = false;

for (var i = 0; i < array_length(balls); i++) {
    if (instance_exists(balls[i])) {
        if (team_is_player(balls[i].owner)) player_alive = true;
        if (team_is_enemy(balls[i].owner)) enemy_alive = true;
    }
}

if (!player_alive && battle_ready) state = BattleState.ENEMY_WIN;
if (!enemy_alive && battle_ready){
	state = BattleState.PLAYER_WIN;
	battle_ready = false;
}


// 1. 현재 룸 이름을 가져옵니다. (예: "Room3_2")
/*var _room_name = room_get_name(room);

// 2. 이름에서 "Room" 부분을 제거합니다. (예: "3_2")
var _stage_string = string_replace(_room_name, "Room", "");

// 3. 추출된 문자열을 '_' 기준으로 나눕니다.
var _parts = string_split(_stage_string, "_");

// 4. 추출된 부분을 인스턴스 변수에 저장합니다.
//    GameMaker의 string_split은 문자열이 없으면 undifined를 반환할 수 있으므로 안전장치 추가
global.current_stage_main = is_array(_parts) && array_length(_parts) > 0 ? _parts[0] : "X";
global.current_stage_sub = is_array(_parts) && array_length(_parts) > 1 ? _parts[1] : "X";

// 5. 최종 표시될 문자열 생성
global.stage_display_text = "Stage " + string(global.current_stage_main) + " - " + string(global.current_stage_sub);

// 'Room1'과 같이 서브 번호가 없는 경우 (예: 'Room1' -> 'Stage 1')
if (global.current_stage_sub == "X") {
    global.stage_display_text = "Stage " + string(global.current_stage_main);
}*/
stage_update_display(room);


// Show the low-friction explanation once per battle. Keeping this state on the
// controller guarantees it works in Room1 and when any battle room is run
// directly from the IDE.
if (!low_friction_tutorial_seen
    && !low_friction_tutorial_active
    && battle_ready
    && generation == low_friction_round) {
    low_friction_tutorial_active = true;
    low_friction_tutorial_open_guard = true;
}

// Ignore a click already held when the warning appears. After release, one
// click anywhere outside the bubble dismisses it for the rest of this battle.
if (low_friction_tutorial_active) {
    if (low_friction_tutorial_open_guard) {
        if (!mouse_check_button(mb_left)) {
            low_friction_tutorial_open_guard = false;
        }
    } else if (mouse_check_button_pressed(mb_left)
        && !point_in_rectangle(mouse_x, mouse_y, 350, 126, 780, 296)) {
        low_friction_tutorial_seen = true;
        low_friction_tutorial_active = false;
    }
}

// Round progression remains a fallback dismissal path.
if (low_friction_tutorial_active && generation > low_friction_round) {
    low_friction_tutorial_seen = true;
    low_friction_tutorial_active = false;
    low_friction_tutorial_open_guard = false;
}
