depth = -2;
// Persistent UI objects also exist as Room1 instances. Keep the existing one
// when returning to Room1 so input and drawing never run twice.
if (instance_number(object_index) > 1) {
	instance_destroy();
	exit;
}
info_opened = false;
// 엔딩 플래그는 최초 실행에만 초기화합니다.
// 이전에는 시작과 동시에 true가 되어 클리어 대사가 노출되었습니다.
if (!variable_global_exists("endclear")) {
	global.endclear = false;
}

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


// GUI는 실제 창 픽셀이 아니라 게임 보드 좌표계(960×960)를 사용합니다.
// 그래야 창이 커져도 스테이지와 글자/아이콘이 같은 비율로 확대됩니다.
display_set_gui_size(room_width, room_height);



if (os_browser != browser_not_a_browser) {
    var _is_mobile = (os_type == os_android || os_type == os_ios);

    if (_is_mobile) {
        show_message("데스크톱 사이트 기능을 이용하시면\n더 원활한 플레이가 가능합니다.");
    }
}
