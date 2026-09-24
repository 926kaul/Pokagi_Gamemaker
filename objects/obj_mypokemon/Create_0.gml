my_pokes = array_create(151, 0);
load_my_pokes();

// This menu owns the top-most GUI drawer when opened.
depth = -100000;

pokeball_opened = false;
x = room_width - 104;
y = 760;

create_pokeball_instances = function() {
    
    // --- 격자 설정 값 ---
    var _start_x = 76;  // balanced side margins inside the wide drawer
    var _start_y = 150; // clear space below the drawer header
    var _step = 38;     // even horizontal and vertical breathing room
    var _cols = 22;     // seven rows fit in the upper half

    // --- 포켓볼 생성 루프 ---
    for (var i = 0; i < 151; i++) {
        
        // 배열 값이 0이 아니면 (포켓몬이 잡혀 있다면)
        if (my_pokes[i] != 0) {
            
            // 1. 격자 위치 계산
            var _col_index = i % _cols;      // 열(Column) 인덱스
            var _row_index = floor(i / _cols); // 행(Row) 인덱스

            // 2. 실제 화면 좌표 계산
            var _x = _start_x + (_col_index * _step);
            var _y = _start_y + (_row_index * _step);
            
            // 3. obj_ball 인스턴스 생성
            var _ball_inst = instance_create_layer(_x, _y, "Instances", obj_ball);
            
            // 4. 인스턴스 정보 저장 및 추적
            _ball_inst.pokemon_id = i+1; // 포켓몬 고유 ID (예: 도감 번호)
			_ball_inst.owner = "player"
			_ball_inst.depth = -5;
            
        }
    }
};

clear_pokeball_instances = function(){
	with (obj_ball) {
	    if (team_is_player(owner) && !placed) {
	        instance_destroy();
	    }
	}
};
