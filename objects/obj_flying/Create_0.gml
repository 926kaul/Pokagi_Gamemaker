depth = -2;
flying_opened = false;
is_active = true; // 뮤츠 보유 여부 등에 따라 제어

// 캔버스 및 GUI 설정 (보내주신 코드)
var _win_w = (os_browser != browser_not_a_browser) ? browser_width : display_get_width();
var _win_h = (os_browser != browser_not_a_browser) ? browser_height : display_get_height();
var _square_size = min(_win_w * 0.95, _win_h * 0.95);

window_set_size(_square_size, _square_size);
display_set_gui_size(_square_size, _square_size); // ✨ GUI 좌표계를 정사각형에 맞춤
window_center();