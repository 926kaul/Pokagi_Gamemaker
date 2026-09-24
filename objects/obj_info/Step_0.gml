// The application surface controls world-render resolution independently of
// the 960x960 room coordinate system. Resizing is deferred until the surface
// exists and GameMaker applies it on the next draw frame.
if (surface_exists(application_surface)) {
    if (surface_get_width(application_surface) != global.render_width
        || surface_get_height(application_surface) != global.render_height) {
        surface_resize(application_surface, global.render_width, global.render_height);
    }
}

if (info_opened) {
    // 1. Draw GUI와 동일한 좌표 계산식 적용
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    var _rect_w = _gui_w * 0.85;
    var _rect_h = _gui_h * 0.85;
    
    var _x2 = (_gui_w - _rect_w) / 2 + _rect_w;
    var _y2 = (_gui_h - _rect_h) / 2 + _rect_h;

    // 2. 하이퍼링크 아이콘 위치 계산 (Draw GUI와 동일하게)
    var _padding = 40;
    var _icon_scale = 0.2;
    var _icon_width = sprite_get_width(link_sprite) * _icon_scale;
    var _icon_height = sprite_get_height(link_sprite) * _icon_scale;
    
    var _link_x = _x2 - _padding - _icon_width;
    var _link_y = _y2 - _padding - _icon_height;

    // 3. GUI 기준 마우스 좌표 가져오기
    var _m_x = device_mouse_x_to_gui(0);
    var _m_y = device_mouse_y_to_gui(0);

    // 4. Hover 상태 확인 및 클릭 처리
    if (_m_x >= _link_x && _m_x <= _link_x + _icon_width && 
        _m_y >= _link_y && _m_y <= _link_y + _icon_height) {
        
        link_is_hovered = true;
        
        if (mouse_check_button_pressed(mb_left)) {
            if (os_browser != browser_not_a_browser) {
                // HTML5(웹) 환경: 새 탭(_blank)에서 열기
                url_open_ext(link_url, "_blank"); 
            } else {
                // 일반 PC 환경
                url_open(link_url);
            }
        }
    } else {
        link_is_hovered = false;
    }
} else {
    link_is_hovered = false;
}
