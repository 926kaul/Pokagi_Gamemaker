// ------------------------------
// (A) 배치 드래그 끝
// ------------------------------
if (is_placing && team_is_player(owner)) {
    is_placing = false;

    // 바둑판 스냅
    var gx = clamp(mouse_x, global.board.left, global.board.right);
    var gy = clamp(mouse_y, global.board.top, global.board.bottom);
    gx = board_snap(gx, global.board.left);
    gy = board_snap(gy, global.board.top);

	// 같은 격자 칸에 여러 포켓몬이 배치되면 전투 시작과 동시에
	// 중심점이 겹치므로 해당 위치는 사용할 수 없게 합니다.
	var position_free = true;
	var placing_id = id;
	with (obj_ball) {
		if (id != placing_id && placed && x == gx && y == gy) {
			position_free = false;
		}
	}
	
	var player_count = 0;
	with (obj_ball) {
	    if (board_is_inside(x, y) && board_is_player_area(y)) {
	        if (team_is_player(owner)) player_count++;
	    }
	}

    // 아래 절반만 허용
    // 현재 배치 수를 세고 난 뒤 새 포켓몬을 추가하므로 3 미만이어야 합니다.
    if (board_is_player_area(mouse_y) && player_count < 3 && position_free) {
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

