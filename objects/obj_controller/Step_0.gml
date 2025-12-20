//-----------------------------------------------------
// 1) 선택 끝 처리 (player/ enemy/ 삭제)
//-----------------------------------------------------
if (selection_done) {

    var p = global.player_choice;
    var enemy_id;

    switch (p) {
        case 1: enemy_id = 7; break;
        case 4: enemy_id = 1; break;
        case 7: enemy_id = 4; break;
    }
	
	for (var i = 0; i < 150; i++) { 
	    // 현재 요소의 값이 1이 아니라면
	    if (obj_mypokemon.my_pokes[i] != 1) {
	        // 플래그를 false로 설정하고 루프를 즉시 종료합니다.
	        _all_caught = false;
	        break; 
	    }
	}
	if (_all_caught) {
	    // 0부터 149까지 모두 1일 경우, enemy_id를 151로 설정합니다.
	    enemy_id = 151; 
	    // (선택 사항) 디버그 메시지로 확인
	    show_debug_message("모든 포켓몬(1-150번)을 잡았습니다! enemy_id를 151로 설정합니다.");
	}
	

    // player를 오른쪽 대기 위치로 이동
    with (obj_ball) {
        if (owner == "player") {
			obj_mypokemon.my_pokes[p-1] = 1;
			instance_destroy();
        }
    }

    // enemy 자동 배치
    with (obj_ball) {
        if (pokemon_id == enemy_id) {
            owner = "enemy";
            x = 480;
            y = 240;
			placed = true;
        }
    }

    // 나머지 삭제
    with (obj_ball) {
        if (owner == "none") {
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
    start_turn_system();        // 아래 정의함
    turn_system_started = true;
}

//-----------------------------------------------------
// 3) 전투 시작 이후의 턴/세대 시스템
//-----------------------------------------------------

switch (state) {

    case "wait_turn":
		show_debug_message("wait_turn" + string(turn_index));
        var current = balls[turn_index];

        with (current) {
            current_turn = true;
        }

        state = "player_input";   // 플레이어 입력 대기
        break;
	
	case "player_input":
		// show_debug_message("player_input" + string(turn_index));
	    current = balls[turn_index];
	    if (current.owner == "enemy") {
	        state = "enemy_act";
	    }
	    break;
	
	case "enemy_act":
		show_debug_message("enemy_act" + string(turn_index));
	    current = balls[turn_index];

	    enemy_take_action(current);
	    state = "moving";
	    break;
	
	case "moving":
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
			state = "end_turn";
		break;

    case "end_turn":
		show_debug_message("end_turn" + string(turn_index));
		var next_ball = balls[turn_index];
		if (instance_exists(next_ball)) { // 인스턴스가 존재하는지 확인
            with (next_ball) current_turn = false;
        }
		turn_index += 1;
		
		if (turn_index >= array_length(balls)) {
            generation += 1;
			
	        // 중심 거리 정렬
	        array_sort(balls, function(a, b) {
	            return point_distance(b.x, b.y, 480, 480) - point_distance(a.x, a.y, 480, 480);
	        });

	        turn_index = 0;
        }
		state = "wait_turn";
		break;
	
	case "player_win":
		player_cnt = 0;
		for (var i = 0; i < array_length(balls); i++) {
			if (instance_exists(balls[i])) {
			    if (balls[i].owner == "player"){
					player_cnt += 1;
					if (global.evol[balls[i].pokemon_id-1]) {
						obj_mypokemon.my_pokes[balls[i].pokemon_id] = 1;
						save_my_pokes();
					}
					
				}
				
			}
		}
		switch(room){
			case Room1:
				room_goto(Room2);
				state = "wait_turn";
				break;
			case Room2:
				room_goto(Room2_1);
				state = "wait_turn";
				break;
			case Room2_1:
				room_goto(Room3);
				state = "wait_turn";
				break;
			case Room3:
				room_goto(Room3_1);
				state = "wait_turn";
				break;
			case Room3_1:
				room_goto(Room4);
				state = "wait_turn";
				break;
			case Room4:
				room_goto(Room4_1);
				state = "wait_turn";
				break;
			case Room4_1:
				room_goto(Room5);
				state = "wait_turn";
				break;
			case Room5:
				if(player_cnt < 3) room_goto(Room5_1);
				else room_goto(Room5_2);
				state = "wait_turn";
				break;
			case Room5_1:
				room_goto(Room6);
				state = "wait_turn";
				break;
			case Room5_2:
				room_goto(Room6);
				state = "wait_turn";
				break;
			case Room6:
				room_goto(Room6_1);
				state = "wait_turn";
				break;
			case Room6_1:
				room_goto(Room7);
				state = "wait_turn";
				break;
			case Room7:
				room_goto(Room7_1);
				state = "wait_turn";
				break;
			case Room7_1:
				room_goto(Room8);
				state = "wait_turn";
				break;
			case Room8:
				if(player_cnt < 3) room_goto(Room8_1);
				else room_goto(Room8_2);
				state = "wait_turn";
				break;
			case Room8_1:
				room_goto(Room9);
				state = "wait_turn";
				break;
			case Room8_2:
				room_goto(Room9);
				state = "wait_turn";
				break;
			case Room9:
				if(player_cnt < 3) room_goto(Room9_1);
				else room_goto(Room9_2);
				state = "wait_turn";
				break;
			case Room9_1:
				room_goto(Room10);
				state = "wait_turn";
				break;
			case Room9_2:
				room_goto(Room10);
				state = "wait_turn";
				break;
			case Room10:
				room_goto(RoomFinal);
				state = "wait_turn";
				break;
			case RoomFinal:
				if(player_cnt < 3) room_goto(Room1);
				else room_goto(RoomReal_Final);
				state = "wait_turn";
				break;
			case RoomReal_Final:
				room_goto(Room1);
				state = "wait_turn";
				break;
		}
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

        // 턴 중에 죽었으면 즉시 다음 턴으로 넘어가도록 보정
        if (turn_index == i && state == "moving") {
			if (turn_index >= array_length(balls)) {
	            generation += 1;
			
		        // 중심 거리 정렬
		        array_sort(balls, function(a, b) {
		            return point_distance(a.x, a.y, 480, 480) <
		                   point_distance(b.x, b.y, 480, 480);
		        });

		        turn_index = 0;
	        }
	
	        state = "wait_turn";
	        break;
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
        if (balls[i].owner == "player") player_alive = true;
        if (balls[i].owner == "enemy") enemy_alive = true;
    }
}

if (!player_alive && battle_ready) state = "enemy_win";
if (!enemy_alive && battle_ready){
	state = "player_win";
	battle_ready = false;
}


// 1. 현재 룸 이름을 가져옵니다. (예: "Room3_2")
var _room_name = room_get_name(room);

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
}




// obj_controller Step Event

var _x = 750;
var _y = 890;
var _w = 100;
var _h = 10;

// obj_controller Step Event

if (instance_exists(obj_controller)) { // 컨트롤러가 존재할 때만 실행
    
    // 1. Draw GUI와 동일한 좌표 및 크기 계산 (변수명 겹침 방지)
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    var _v_bar_w = 150; 
    var _v_bar_h = 10;
    var _v_padding = 40;

    var _v_draw_x = _gui_w - _v_bar_w - _v_padding;
    var _v_draw_y = _gui_h - _v_bar_h - _v_padding - 20;

    // 2. ✨ 중요: GUI 기준 마우스 좌표 가져오기
    var _m_gui_x = device_mouse_x_to_gui(0);
    var _m_gui_y = device_mouse_y_to_gui(0);

    // 3. 마우스 오버 확인 (GUI 좌표 기준)
    var _vol_mouse_over = (_m_gui_x >= _v_draw_x && _m_gui_x <= _v_draw_x + _v_bar_w && 
                           _m_gui_y >= _v_draw_y && _m_gui_y <= _v_draw_y + _v_bar_h);

    // 4. 클릭 및 드래그 처리
    if (mouse_check_button(mb_left) && _vol_mouse_over) {
        
        // 마우스의 GUI X 위치를 볼륨 바 내의 상대적 위치로 변환
        var _v_relative_x = _m_gui_x - _v_draw_x;
        
        // 비율 계산 (0.0 ~ 1.0) 및 클램프
        var _v_new_vol = clamp(_v_relative_x / _v_bar_w, 0.0, 1.0);
        
        // 전역 변수 업데이트 및 실제 볼륨 적용
        global.master_volume = _v_new_vol;
        
        // 해당 함수가 정의되어 있는지 확인 후 호출
        if (script_exists(set_master_volume) || asset_get_index("set_master_volume") != -1) {
            set_master_volume(global.master_volume*0.5);
        }
    }
}