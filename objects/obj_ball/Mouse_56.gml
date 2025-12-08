// ------------------------------
// (B) 샷 드래그 끝 (발사)
// Global Left Released 이벤트
// ------------------------------
if (is_shooting && owner == "player") {
    is_shooting = false;

    // 1) 당긴 거리 계산
    var sx = pull_start_x;
    var sy = pull_start_y;

    var dx = sx - mouse_x;
    var dy = sy - mouse_y;

    var X = point_distance(sx, sy, mouse_x, mouse_y);
	var X_actual = point_distance(sx, sy, mouse_x, mouse_y);

    // 2) 최대 당김 200px
    var max_pull = 200;
    if (X > max_pull) {
        X = max_pull;
    }

    // 3) 커브 (0~1 → 0~1)
    var t = 0;
    if (max_pull > 0) {
        t = X / max_pull;     // 0 ~ 1
    }
    var force = t * t * (3 - 2 * t);

    // 4) 방향 단위 벡터 (슬링샷: 당긴 반대 방향으로 발사)
    var nx = 0;
    var ny = 0;
    if (X > 0) {
        nx = dx / X_actual;   // (sx - mouse_x) / X
        ny = dy / X_actual;
    }

    // 5) 최대 속도 크기 설정
    // friction = 0.95 기준 → D = V / (1 - 0.95) = V / 0.05
    // D_max = 400 → V_max = 400 * 0.05 = 20
    var max_speed = stats.max_speed+5;

    // 최종 속도
    velocity_x = nx * force * max_speed;
    velocity_y = ny * force * max_speed;
	show_debug_message("n_x:" + string(nx) + " n_y:" + string(ny));
	show_debug_message("force:" + string(force) + " max_speed:" + string(max_speed));
	show_debug_message("v_x:" + string(velocity_x) + " v_y:" + string(velocity_y));

    moving = true;

    with (obj_controller) state = "moving";
}
