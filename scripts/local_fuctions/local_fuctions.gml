function start_turn_system() {

	var ctrl = id;
	// 재호출되더라도 이전 인스턴스 참조가 남지 않도록 항상 새로 구성합니다.
	ctrl.balls = [];

    with (obj_ball) {
        if (placed && team_is_active(owner)) {
            array_push(ctrl.balls, id);
        }
    }

    array_sort(ctrl.balls, function(a, b) {
        return board_distance_from_center(b) - board_distance_from_center(a);
    });

    turn_index = 0;
    generation = 1;
    low_friction_tutorial_seen = false;
    low_friction_tutorial_active = false;
    low_friction_tutorial_open_guard = false;
    state = BattleState.WAIT_TURN;
}


function enemy_take_action(enemy_inst) {
	
    var player_list = array_create(0);

    with (obj_ball) {
        if (team_is_player(owner)) array_push(player_list, id);
    }
	
	
    if (array_length(player_list) == 0) return;

    var target = player_list[irandom(array_length(player_list) - 1)];

    var base_angle = point_direction(enemy_inst.x, enemy_inst.y, target.x, target.y);
    var shoot_angle = base_angle + random_range(-5, 5);
		

    var pull_power = irandom_range(3, 5);

    var max_pull = global.board.max_pull;
    var X = pull_power * (max_pull / 5);

    var t = X / max_pull;
    var force = t * t * (3 - 2 * t);

    var max_speed = enemy_inst.stats.max_speed;

    enemy_inst.velocity_x = dcos(shoot_angle) * force * max_speed;
    enemy_inst.velocity_y = -dsin(shoot_angle) * force * max_speed;

    enemy_inst.moving = true;
	
}

/// @function select_enemies_for_room(target_ids, count)
function select_enemies_for_room(_target_ids, _count) {
    
    var _mypokemon_inst = instance_find(obj_mypokemon, 0);
    var _selected_ids = [];
    
    if (!instance_exists(_mypokemon_inst) || array_length(_target_ids) == 0 || _count <= 0) {
        return _selected_ids;
    }
    
    // 1. 잡지 않은 포켓몬 ID 목록(_available_ids) 생성
    var _available_ids = [];
    var _caught_ids = [];
    
    for (var i = 0; i < array_length(_target_ids); i++) {
        var _id = _target_ids[i];
        if (!profile_is_caught(_id)) {
            array_push(_available_ids, _id); // 아직 잡지 않음
        } else {
            array_push(_caught_ids, _id); // 이미 잡음
        }
    }
    
    // 2. 선택 로직: 잡지 않은 포켓몬 우선 선택
    
    if (array_length(_available_ids) >= _count) {
        // A. 잡지 않은 포켓몬이 충분할 경우: 그 중에서 count만큼 랜덤 선택
        _available_ids = array_shuffle(_available_ids);
				
        for (var i = 0; i < _count; i++) {
            array_push(_selected_ids, _available_ids[i]);
        }
    } 
    else {
        // B. 잡지 않은 포켓몬이 부족할 경우:
        
        // 2-1. 잡지 않은 포켓몬을 모두 추가 (우선 순위)
        _selected_ids = _available_ids;
        
        // 2-2. 부족한 만큼 '이미 잡은 포켓몬' 목록에서 랜덤하게 채우기 (중복 방지)
        var _needed = _count - array_length(_selected_ids);
        
        // 이미 잡은 포켓몬(_caught_ids)을 섞어서 랜덤성을 확보
        _caught_ids = array_shuffle(_caught_ids); 
        
        for (var i = 0; i < _needed; i++) {
            // 잡은 포켓몬 목록에서 부족한 만큼 랜덤하게 가져옴
            if (i < array_length(_caught_ids)) {
                array_push(_selected_ids, _caught_ids[i]);
            }
        }
    }
    
    // 최종 결과 배열도 한 번 더 섞어주면 순서 랜덤성을 확실히 보장할 수 있습니다.
    _selected_ids = array_shuffle(_selected_ids); 
	
    
    return _selected_ids;
}

function spawn_enemies_for_room(_target_ids, _count) {
    
    // 1. 고정된 소환 영역 (하드코딩)
    var _x_min = global.board.left;
    var _x_max = global.board.right;
    var _y_min = global.board.top;
    var _y_max = global.board.player_top - global.board.grid_size;
    
    // 1. 소환할 포켓몬 ID 선택 (기존 select_enemies_for_room 함수 사용)
    var _selected_ids = select_enemies_for_room(_target_ids, _count);
    
    if (array_length(_selected_ids) == 0) {
        show_debug_message("경고: 소환할 포켓몬 ID를 선택할 수 없습니다.");
        return;
    }
    
    // 2. 소환 위치 생성 (겹치지 않게)
    var _positions = [];
    var _attempts = 0;
    
    // 포켓몬의 실제 크기까지 고려해 겹치지 않는 위치를 찾습니다.
    while (array_length(_positions) < array_length(_selected_ids) && _attempts < 500) {
        var _x_new = irandom_range(_x_min, _x_max);
        var _y_new = irandom_range(_y_min, _y_max);
        var _is_duplicate = false;
        var _new_index = array_length(_positions);
        var _new_id = _selected_ids[_new_index];
        var _new_radius = 20 * global.poke_stats[_new_id].size;
        
        // 이미 생성된 위치와 겹치는지 확인
        for (var i = 0; i < array_length(_positions); i++) {
            var _placed_id = _selected_ids[i];
            var _placed_radius = 20 * global.poke_stats[_placed_id].size;
            var _min_distance = _new_radius + _placed_radius + 4;
            if (point_distance(_x_new, _y_new, _positions[i][0], _positions[i][1]) < _min_distance) {
                _is_duplicate = true;
                break;
            }
        }
        
        if (!_is_duplicate) {
            array_push(_positions, [_x_new, _y_new]);
        }
        _attempts++;
    }

    // 3. 인스턴스 생성 및 속성 설정
    for (var i = 0; i < array_length(_selected_ids); i++) {
        var _id = _selected_ids[i];
        
        // 위치를 성공적으로 찾았다면 (선택된 ID 개수보다 위치 개수가 적을 수 있음)
        if (i < array_length(_positions)) {
            var _pos = _positions[i];
            
            var _ball_inst = instance_create_layer(_pos[0], _pos[1], "Instances", obj_ball);
            
            // 속성 설정
            _ball_inst.owner = "enemy";
            _ball_inst.pokemon_id = _id;
            _ball_inst.placed = true; 
            
        } else {
            show_debug_message("경고: 충분한 고유 소환 위치를 찾지 못했습니다. 소환 마릿수 미달.");
        }
    }
}


/// @function save_my_pokes()
/// @desc my_pokes 배열을 길이 151의 '0'/'1' 문자열로 변환하여 파일에 저장합니다.
function save_my_pokes() {
    
    var _mypokemon_inst = instance_find(obj_mypokemon, 0);
    if (!instance_exists(_mypokemon_inst)) {
        return; 
    }
    
    var _save_key = "poke_status_str";
    var _pokes_array = _mypokemon_inst.my_pokes;
    var _array_len = array_length(_pokes_array);
    
    // 1. 문자열을 미리 길이 151의 '0'으로 초기화
    var _save_string = string_repeat("0", _array_len); 
    
    // 2. 배열을 순회하며 잡은 포켓몬('1') 위치를 문자열에 기록
    for (var i = 0; i < _array_len; i++) {
        if (_pokes_array[i] == 1) { 
            // 문자열 인덱스 (GML string 함수는 1부터 시작)
            var _char_pos = i + 1;
            
            // 💡 FIX: string_set_at 대신 문자열 분리 및 재결합을 사용하여 문자를 대체합니다.
            // (1) 해당 위치 이전 문자열 + (2) '1' 문자 + (3) 해당 위치 이후 문자열
            
            // 1) 해당 위치 이전 문자열 (1부터 _char_pos - 1까지)
            var _part_before = string_copy(_save_string, 1, _char_pos - 1);
            
            // 2) 해당 위치 이후 문자열 (_char_pos + 1부터 끝까지)
            var _part_after = string_copy(_save_string, _char_pos + 1, string_length(_save_string) - _char_pos);
            
            // 3) 새로운 문자열 생성 (불변성 유지)
            _save_string = _part_before + "1" + _part_after;
        }
    }
    
    // 3. LocalStorage에 저장
    var _file = file_text_open_write(_save_key);
    file_text_write_string(_file, _save_string);
    file_text_close(_file);

    show_debug_message("저장된 문자열: " + _save_string);
}


function load_my_pokes() {
    
    var _mypokemon_inst = instance_find(obj_mypokemon, 0);
    if (!instance_exists(_mypokemon_inst)) {
        return; 
    }
    
    var _save_key = "poke_status_str";
    var _temporary_v2_key = "poke_status_str_v2";

    // 1. 새 배열을 0으로 초기화
    var _new_pokes_array = array_create(151, 0); 
    var _save_string = "";
    
    // 2. LocalStorage에서 문자열 불러오기
    if (file_exists(_save_key)) {
        var _file = file_text_open_read(_save_key);
        _save_string = file_text_read_string(_file); 
        file_text_close(_file);
    } else if (file_exists(_temporary_v2_key)) {
        // Preserve progress created while the temporary v2 key was active,
        // then migrate it back to the original key used by existing players.
        var _v2_file = file_text_open_read(_temporary_v2_key);
        _save_string = file_text_read_string(_v2_file);
        file_text_close(_v2_file);

        if (string_length(_save_string) >= 151) {
            var _legacy_file = file_text_open_write(_save_key);
            file_text_write_string(_legacy_file, _save_string);
            file_text_close(_legacy_file);
        }
    }
    
    // 저장된 문자열이 없거나 길이가 잘못되었다면 여기서 종료 (모두 0인 배열 유지)
    if (string_length(_save_string) < 151) { 
        _mypokemon_inst.my_pokes = _new_pokes_array;
        return;
    }
    
    // 3. 문자열을 확인하여 배열 복원
    var _array_len = array_length(_new_pokes_array);
    
    for (var i = 0; i < _array_len; i++) {
        // 문자열 인덱스: 배열 인덱스(i)는 0부터 시작하지만, 
        // GML의 string_char_at 함수는 위치를 1부터 시작합니다.
        var _char_pos = i + 1;
        
        // 문자열의 해당 위치 문자가 '1'인지 확인
        if (string_char_at(_save_string, _char_pos) == "1") {
            // 잡았으면 배열의 해당 인덱스(i)에 1을 설정
            _new_pokes_array[i] = 1;
        }
    }
    
    // 4. 최종 결과를 obj_mypokemon에 할당합니다.
    _mypokemon_inst.my_pokes = _new_pokes_array;
    
    show_debug_message("로드된 my_pokes 배열 길이: " + string(array_length(_new_pokes_array)));
}



/// @function set_master_volume(volume)
function set_master_volume(_volume) {
    audio_group_set_gain(audiogroup_default, clamp(_volume, 0, 1), 0);
}
