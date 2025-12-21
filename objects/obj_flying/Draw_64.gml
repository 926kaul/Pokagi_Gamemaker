// 1. 마우스 GUI 좌표
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// 2. ✨ 핵심: 오브젝트의 룸 좌표(x, y)를 GUI 좌표로 변환
// 정사각형 캔버스 설정 때문에 룸 좌표를 그대로 쓰면 어긋납니다.
var _gui_x = (x / room_width) * display_get_gui_width();
var _gui_y = (y / room_height) * display_get_gui_height();

// 3. 아이콘 클릭 판정 (메뉴가 닫혀있을 때 아이콘 위치 클릭 체크)
// else if 구조를 사용하여 '열기'가 성공한 프레임에는 아래 '닫기' 로직이 실행되지 않도록 차단합니다.
if (!flying_opened) {
    if (mouse_check_button_pressed(mb_left)) {
        // 이제 오브젝트를 룸에서 어디로 옮기든 _gui_x, _gui_y가 따라갑니다.
        if (point_in_circle(_mx, _my, _gui_x, _gui_y, 40)) {
            flying_opened = true;
        }
    }
}
// 4. 공중날기 메뉴 출력 (보내주신 2x5 그리드 코드)
else if (flying_opened && is_active) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    // 1. 하단 영역 좌표 계산 (이전과 동일)
    var _half_h = _gui_h / 2;
    var _rect_w = _gui_w * 0.95;
    var _rect_h = _half_h * 0.95;
    
    var _x1 = (_gui_w - _rect_w) / 2;
    var _y1 = _half_h + (_half_h - _rect_h) / 2;
    
    // 배경 (남색 포켓몬 스타일)
    draw_set_colour(make_colour_rgb(32, 32, 96));
    draw_roundrect_ext(_x1, _y1, _x1 + _rect_w, _y1 + _rect_h, 15, 15, false);
    
    // 2. 2x5 그리드 설정
    var _rooms = [Room1, Room2_1, Room3_1, Room4_1, Room5_1, Room6_1, Room7_1, Room8_1, Room9_1, Room10];
    var _cols = 5; // 가로 5칸
    var _rows = 2; // 세로 2칸
        
    // 버튼 크기 및 간격 계산
    var _padding = 15; 
    var _btn_w = (_rect_w - (_padding * (_cols + 1))) / _cols;
    var _btn_h = (_rect_h - (_padding * (_rows + 1))) / _rows;

    var _any_button_clicked = false; // 버튼 클릭 여부 확인용

    for (var i = 0; i < array_length(_rooms); i++) {
        // 그리드 위치(열, 행) 계산
        var _col = i % _cols;
        var _row = i div _cols;
            
        // 개별 버튼의 좌표
        var _bx = _x1 + _padding + (_col * (_btn_w + _padding));
        var _by = _y1 + _padding + (_row * (_btn_h + _padding));
            
        // ✨ 이름 처리: "Room"을 제거하고 숫자/식별자만 남김
        var _raw_name = room_get_name(_rooms[i]);
        var _display_number = string_replace(_raw_name, "Room", ""); 

// --- 좌표 계산 (원형 버튼의 중심점) ---
        // 원의 중심은 버튼 영역의 정중앙입니다.
        var _center_x = _bx + (_btn_w / 2);
        var _center_y = _by + (_btn_h / 2);
        var _radius = _btn_w / 2; // 지름이 _btn_w이므로 반지름은 그 절반
        
        // point_in_rectangle 대신 point_in_circle을 사용합니다.
        var _hover = point_in_circle(_mx, _my, _center_x, _center_y, _radius);
            
        // --- 버튼 그리기 (원형으로 변경) ---
        // 내부 채우기
        draw_set_color(_hover ? make_colour_rgb(192, 192, 128) : c_white);
        draw_circle(_center_x, _center_y, _radius, false);
            
        // 테두리
        draw_set_color(c_black);
        draw_circle(_center_x, _center_y, _radius, true);
		
        draw_set_font(Font3);    
        // 텍스트 출력 (숫자만)
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_bx + (_btn_w/2), _by + (_btn_h/2), "Stage\n\n"+_display_number);
            
        // 클릭 이벤트
        if (_hover && mouse_check_button_pressed(mb_left)) {
            _any_button_clicked = true;
            room_goto(_rooms[i]);
        }
    }

    // 메뉴 닫기 로직 (박스 바깥 클릭 시)
    // 버튼 클릭이 발생하지 않았을 때만 바깥 영역 클릭을 체크합니다.
    if (!_any_button_clicked && mouse_check_button_pressed(mb_left)) {
        if (!point_in_rectangle(_mx, _my, _x1, _y1, _x1 + _rect_w, _y1 + _rect_h)) {
            flying_opened = false;
        }
    }
}