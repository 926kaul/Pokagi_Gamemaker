// ------------------------------
// (A) 배치 드래그 끝
// ------------------------------
if (is_placing && owner == "player") {
    is_placing = false;

    // 바둑판 스냅
    var gx = clamp(mouse_x, 120, 840);
    var gy = clamp(mouse_y, 120, 840);
    gx = 120 + round((gx - 120) / 40) * 40;
    gy = 120 + round((gy - 120) / 40) * 40;
	
	var player_count = 0;
	with (obj_ball) {
	    if (x >= 120 && x <= 840 && y >= 480 && y <= 840) {
	        if (owner == "player") player_count++;
	    }
	}

    // 아래 절반만 허용
    if (mouse_y >= 480 && player_count <= 3) {
        x = gx;
        y = gy;
        placed = true;
		depth = 0;
		
		// 1. obj_mypokemon (창) 인스턴스를 찾습니다.
        var _window = instance_find(obj_mypokemon, 0); 
        
        if (instance_exists(_window)) {
            // 2. 창 오브젝트의 삭제 리스트에서 현재 obj_ball 인스턴스 ID를 찾습니다.
            // 'id'는 현재 실행 중인 obj_ball 인스턴스의 고유 ID입니다.
            var _index = ds_list_find_index(_window.pokeball_instance_list, id);
            
            // 3. 리스트에 ID가 존재하면 (인덱스가 -1이 아니면) 삭제합니다.
            if (_index != -1) {
                ds_list_delete(_window.pokeball_instance_list, _index);
                
                // [참고] 이제 이 인스턴스는 창이 닫혀도 살아남게 됩니다.
            }
        }
		
    } else {
        // 원래 자리 복구
        x = original_x;
        y = original_y;
    }
}

