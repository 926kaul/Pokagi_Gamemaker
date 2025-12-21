depth = -2;
info_opened = false;
global.endclear = false;

link_url = "https://github.com/926kaul/Pokagi";
link_is_hovered = false;
link_sprite = github_sprite;

// --- 캔버스 설정 (정사각형 유지) ---

// 1. 브라우저/디스플레이 크기 가져오기
// HTML5라면 browser_width/height를 사용하는 것이 더 정확할 수 있어.
var _win_w = (os_browser != browser_not_a_browser) ? browser_width : display_get_width();
var _win_h = (os_browser != browser_not_a_browser) ? browser_height : display_get_height();

// 2. 95% 영역 내 최대 정사각형 크기 계산
var _square_size = min(_win_w * 0.95, _win_h * 0.95);

// 3. 윈도우 크기 설정
window_set_size(_square_size, _square_size);


// 4. ✨ 가장 중요한 포인트: GUI 크기 재설정
// 이걸 안 하면 화면은 커져도 GUI 좌표(버튼 클릭 등)는 옛날 크기에 머물러 있게 돼.
display_set_gui_size(_square_size, _square_size);



if (os_browser != browser_not_a_browser) {
    var _is_mobile = (os_type == os_android || os_type == os_ios);

    if (_is_mobile) {
        show_message("데스크톱 사이트 기능을 이용하시면\n더 원활한 플레이가 가능합니다.");
    }
}