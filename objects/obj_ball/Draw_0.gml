draw_self();
if(owner == "enemy") image_blend = make_colour_rgb(255, 191, 191);;

// 샷 조준 중이면 라인 그리기
if (is_shooting) {

    var max_len = 200;

    // 마우스로부터 당긴 벡터
    var dx = mouse_x - x;
    var dy = mouse_y - y;

    var dist = point_distance(x, y, mouse_x, mouse_y);
	var lx, ly;

    // 방향 유지하며 길이 제한
    if (dist > max_len) {
        var dir = point_direction(x, y, mouse_x, mouse_y);
        lx = x + lengthdir_x(max_len, dir);
        ly = y + lengthdir_y(max_len, dir);
    } else {
        // 200 이하일 때는 그대로 표시
        lx = mouse_x;
        ly = mouse_y;
    }

    draw_set_color(c_lime);
    draw_line(x, y, lx, ly);
    draw_set_color(c_white);
}



// 디버그 궤적 그리기
draw_set_alpha(0.6);  
draw_set_color(c_aqua);

for (var i = 1; i < array_length(trail); i++) {
    var p1 = trail[i-1];
    var p2 = trail[i];
    draw_line(p1[0], p1[1], p2[0], p2[1]);
}

draw_set_alpha(1);
draw_set_color(c_white);


if (current_turn == true && !moving) {
    
    // 1. 텍스트 설정
	draw_set_font(Font3);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(make_colour_rgb(127, 255, 0));
    
    // 2. 텍스트 그리기
    // x: 공의 중앙 (x)
    // y: 공의 중앙에서 공 높이의 절반 + 약간의 여백 (y + sprite_height/2 + 5)
    draw_text(
        x, 
        y + sprite_height / 2 + 5, 
        "TURN"
    );

    // 3. 설정 초기화 (선택 사항이지만 좋은 습관)
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

