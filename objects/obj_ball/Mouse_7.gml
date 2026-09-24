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

	// Preview and release share the same occupancy/count helpers.
	var position_free = board_position_is_free(gx, gy, id);
	var player_count = board_player_placed_count();

    // 아래 절반만 허용
    // 현재 배치 수를 세고 난 뒤 새 포켓몬을 추가하므로 3 미만이어야 합니다.
    if (board_is_player_area(mouse_y) && player_count < 3 && position_free) {
        x = gx;
        y = gy;
        placed = true;
		depth = 0;
		
    } else {
        // Collection icons always return to their exact grid slot. Keeping a
        // dedicated home coordinate prevents drag event ordering from
        // overwriting the return point with an intermediate mouse position.
        x = has_collection_home ? collection_home_x : original_x;
        y = has_collection_home ? collection_home_y : original_y;
    }
}

