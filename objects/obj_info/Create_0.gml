depth = -2;
// Persistent UI objects also exist as Room1 instances. Keep the existing one
// when returning to Room1 so input and drawing never run twice.
if (instance_number(object_index) > 1) {
	instance_destroy();
	exit;
}
info_opened = false;
modal_open_guard = false;
// 엔딩 플래그는 최초 실행에만 초기화합니다.
// 이전에는 시작과 동시에 true가 되어 클리어 대사가 노출되었습니다.
if (!variable_global_exists("endclear")) {
	global.endclear = profile_load_champion();
}

link_url = "https://github.com/926kaul/Pokagi";
link_is_hovered = false;
link_sprite = github_sprite;

// --- Responsive 5:3 canvas for the dual-monitor layout ---

// 1. 브라우저/디스플레이 크기 가져오기
// HTML5라면 browser_width/height를 사용하는 것이 더 정확할 수 있어.
var _win_w = (os_browser != browser_not_a_browser) ? browser_width : display_get_width();
var _win_h = (os_browser != browser_not_a_browser) ? browser_height : display_get_height();

// 2. Fit a 5:3 window inside 95% of the available display.
var _available_w = floor(_win_w * 0.95);
var _available_h = floor(_win_h * 0.95);
var _window_w = _available_w;
var _window_h = floor(_window_w * 3 / 5);
if (_window_h > _available_h) {
    _window_h = _available_h;
    _window_w = floor(_window_h * 5 / 3);
}

// 3. Apply the widescreen tabletop window.
window_set_size(_window_w, _window_h);

// Small browser canvases use 1x to avoid a 3200x1920 back buffer. Desktop
// builds and sufficiently large browser windows retain the crisp 2x surface.
var _small_browser = os_browser != browser_not_a_browser
    && (_win_w < room_width || _win_h < room_height);
global.render_scale = _small_browser ? 1 : 2;
global.render_width = room_width * global.render_scale;
global.render_height = room_height * global.render_scale;

// Keep the source pixel art crisp. Vector UI and SDF fonts scale independently.
gpu_set_texfilter(false);

// GUI uses the 1600x960 logical coordinate system at every browser size.
// 그래야 창이 커져도 스테이지와 글자/아이콘이 같은 비율로 확대됩니다.
display_set_gui_size(room_width, room_height);

// Persistent utility controls live in the dedicated right-side rail.
x = room_width - 144;
y = 24;



if (os_browser != browser_not_a_browser) {
    var _is_mobile = (os_type == os_android || os_type == os_ios);

    if (_is_mobile) {
        show_message("데스크톱 사이트 기능을 이용하시면\n더 원활한 플레이가 가능합니다.");
    }
}
