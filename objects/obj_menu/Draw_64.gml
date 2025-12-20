// 상성표 버튼 객체의 Draw GUI 이벤트

if (menu_opened) { // 상성표 열림 여부를 체크하는 변수 (기존 info_opened와 별개)
    
    // 1. GUI 크기 및 배경 계산 (설명창과 동일한 85% 크기)
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    var _rect_w = _gui_w * 0.85;
    var _rect_h = _gui_h * 0.85;
    
    var _x1 = (_gui_w - _rect_w) / 2;
    var _y1 = (_gui_h - _rect_h) / 2;
    var _x2 = _x1 + _rect_w;
    var _y2 = _y1 + _rect_h;

    // 남색 배경 사각형 그리기
    draw_set_colour(make_colour_rgb(32, 32, 96));
    draw_roundrect_ext(_x1, _y1, _x2, _y2, 20, 20, false);

    // ----------------------------------------
    // 2. 상성표 스프라이트 출력 (배경의 90% 크기)
    // ----------------------------------------
    
    var _spr = typevs_sprite;
    var _spr_w = sprite_get_width(_spr);
    var _spr_h = sprite_get_height(_spr);

    // 배경 사각형의 90%에 해당하는 목표 크기
    var _target_w = _rect_w * 0.9;
    var _target_h = _rect_h * 0.9;

    // 가로/세로 비율 중 더 작은 쪽에 맞춰 스케일 계산 (이미지 왜곡 방지)
    var _scale_x = _target_w / _spr_w;
    var _scale_y = _target_h / _spr_h;
    var _final_scale = min(_scale_x, _scale_y);

    // 중앙 정렬 좌표 계산
    var _draw_spr_x = (_gui_w / 2) - ((_spr_w * _final_scale) / 2);
    var _draw_spr_y = (_gui_h / 2) - ((_spr_h * _final_scale) / 2);

    // 스프라이트 그리기
    draw_sprite_ext(
        _spr, 
        0, 
        _draw_spr_x, 
        _draw_spr_y, 
        _final_scale, 
        _final_scale, 
        0, 
        c_white, 
        1
    );
}