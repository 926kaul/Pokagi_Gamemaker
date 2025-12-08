// obj_info Step Event

// 정보 창이 열려 있을 때만 처리
if (info_opened) {
    
    // 네모 창의 좌표
    var _x2 = 880;
    var _y2 = 400;

    var _scale = 0.2; // ✨ 스케일 값 적용
    var _padding = 20;
    
    // ✨ 스케일링된 아이콘 크기 계산
    var _icon_width = sprite_get_width(link_sprite) * _scale;
    var _icon_height = sprite_get_height(link_sprite) * _scale;
    
    // 아이콘 위치 계산 (우측 하단)
    var _link_x = _x2 - _padding - _icon_width; 
    var _link_y = _y2 - _padding - _icon_height;
    
    // 마우스가 버튼 영역 위에 있는지 감지 (스케일링된 영역 사용)
    var _mouse_over = mouse_x >= _link_x && mouse_x <= _link_x + _icon_width && 
                      mouse_y >= _link_y && mouse_y <= _link_y + _icon_height;

    link_is_hovered = _mouse_over;

    if (_mouse_over) {
        // 클릭 감지
        if (mouse_check_button_released(mb_left)) {
            url_open(link_url);
        }
    }
} else {
    link_is_hovered = false;
}