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
		
    } else {
        // 원래 자리 복구
        x = original_x;
        y = original_y;
    }
}

