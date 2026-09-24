my_pokes = array_create(151, 0);
load_my_pokes();

depth = -1;

pokeball_opened = false;

create_pokeball_instances = function() {
    
    // --- 격자 설정 값 ---
    var _start_x = 100; // 창 내부 시작 X 좌표
    var _start_y = 60; // 창 내부 시작 Y 좌표
    var _step = 40;    // 포켓볼 간 간격 (40px)
    var _cols = 20;    // 한 줄의 최대 포켓볼 수

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
