depth = -2;
menu_opened = false; // 상성표 창 제어 변수

/// @description 95% 크기를 유지하는 정사각형 캔버스 및 GUI 설정

// 1. 브라우저 또는 디스플레이 크기 가져오기
var _win_w = (os_browser != browser_not_a_browser) ? browser_width : display_get_width();
var _win_h = (os_browser != browser_not_a_browser) ? browser_height : display_get_height();

// 2. 95% 영역 내 최대 정사각형 크기 계산
var _square_size = min(_win_w * 0.95, _win_h * 0.95);

// 3. 윈도우 크기 설정
window_set_size(_square_size, _square_size);

// 4. ✨ 핵심: GUI 레이어 크기를 윈도우와 1:1로 맞춤
// 이걸 해야 상성표 배경 사각형과 클릭 판정이 정확해져!
display_set_gui_size(_square_size, _square_size);

// 5. 창을 브라우저 중앙으로 보냄
window_center();