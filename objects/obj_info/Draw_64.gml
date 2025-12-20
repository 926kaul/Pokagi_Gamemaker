
if (info_opened) {
    // 1. GUI 크기 가져오기 (실행 환경 대응)
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    // 2. 배경 사각형 계산 (화면의 85% 크기)
    var _rect_w = _gui_w * 0.85;
    var _rect_h = _gui_h * 0.85;
    
    // 중앙 배치를 위한 좌표 계산
    var _x1 = (_gui_w - _rect_w) / 2;
    var _y1 = (_gui_h - _rect_h) / 2;
    var _x2 = _x1 + _rect_w;
    var _y2 = _y1 + _rect_h;

    // 배경 그리기 (남색)
    draw_set_colour(make_colour_rgb(16, 16, 64));
    draw_roundrect_ext(_x1, _y1, _x2, _y2, 20, 20, false);

    // ----------------------------------------
    // 3. 설명 텍스트 추가 (상성표 제거 후 위치 재조정)
    // ----------------------------------------
    
    // 텍스트 여백 설정
    var _padding = 40;
    var _text_x = _x1 + _padding;
    var _text_y = _y1 + _padding;
    var _max_width = _rect_w - (_padding * 2);

    draw_set_font(Font5);
    draw_set_color(c_white); 
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    var _info_text_ko = 
	    "1. 충돌 후 속도는 타입 상성이 반영되어 결정됩니다. 충돌하는 두 포켓몬의 타입1과 타입2가 모두 계산에 반영됩니다 (1세대 상성 기준).\n\n" +
	    "2. 포켓몬의 크기는 종족값의 HP, 운동 질량은 공격이나 특수, 정지 질량은 방어나 특수, 최대 속도는 스피드 수치에 의해 결정됩니다.\n\n" +
	    "3. 잡은 포켓몬은 포켓몬 도감에 등록되며, 다음 스테이지부터 사용할 수 있습니다.\n\n"+
		"4. 승리 시점에 생존해 있는 포켓몬은 진화할 수 있습니다.\n\n" +
	    "5. 전투에서 내 포켓몬 3마리가 모두 생존한 상태로 승리하면 히든 스테이지가 잠금 해제됩니다.\n\n" +
	    "6. 빠른 진행을 위해, Gen 6 이후부터는 마찰력이 크게 감소합니다.\n\n" +
		"7. 전장 가장자리의 불편한 조작감은 현실 알까기를 반영한 것입니다.\n\n" +
	    "8. 더 자세한 정보가 필요하시면, Github page를 방문해 주시기 바랍니다.";
                 
    // 텍스트 출력
    draw_text_ext(_text_x, _text_y, _info_text_ko, -1, _max_width);
    
    // ----------------------------------------
    // 4. 하이퍼링크 아이콘 (우측 하단 고정)
    // ----------------------------------------

    var _icon_scale = 0.2;
    var _icon_width = sprite_get_width(link_sprite) * _icon_scale;
    var _icon_height = sprite_get_height(link_sprite) * _icon_scale;
    
    // 네모 창의 우측 하단에서 여백만큼 안으로 배치
    var _link_x = _x2 - _padding - _icon_width;
    var _link_y = _y2 - _padding - _icon_height;
    
    // 마우스 오버 체크 (GUI 좌표 기준으로 체크해야 함)
    var _m_x = device_mouse_x_to_gui(0);
    var _m_y = device_mouse_y_to_gui(0);
    
    var _hover = (_m_x >= _link_x && _m_x <= _link_x + _icon_width && 
                  _m_y >= _link_y && _m_y <= _link_y + _icon_height);

    var _draw_color = c_white;
    if (_hover) {
        _draw_color = make_colour_rgb(200, 200, 255); 
        window_set_cursor(cr_handpoint); 
    } else {
        // 주의: 다른 버튼에서도 cursor를 제어한다면 이 부분은 조심해서 다뤄야 함
        // window_set_cursor(cr_default); 
    }

    draw_sprite_ext(
        link_sprite, 0, _link_x, _link_y, 
        _icon_scale, _icon_scale, 0, _draw_color, 1 
    );
}