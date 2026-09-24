// Remaster HUD: independent cards keep every battle concept readable.
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Team selection is a full workspace. Hide the battle HUD while it is open so
// the collection drawer can use the full upper area without visual collisions.
var _collection_open = instance_exists(obj_mypokemon)
    && obj_mypokemon.pokeball_opened
    && !battle_ready;
if (_collection_open) {
    draw_set_font(Font5);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_colour(ui_colour("ivory"));
    draw_text(992, 792, "지닌 포켓몬");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

var _ivory = ui_colour("ivory");
var _coral = ui_colour("coral");
var _cyan = ui_colour("cyan");
var _gold = ui_colour("gold");
var _muted = ui_colour("muted");
var _divider = make_colour_rgb(55, 69, 78);

var _player_count = 0;
var _enemy_count = 0;
with (obj_ball) {
    if (placed) {
        if (team_is_player(owner)) _player_count++;
        if (team_is_enemy(owner)) _enemy_count++;
    }
}

// Card 1: round and physics mode.
ui_draw_panel(20, 16, 184, 106, 10, _gold);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(Font5);
draw_set_colour(_ivory);
draw_text_transformed(102, 52, "라운드 " + string(generation), 1.15, 1.15, 0);
draw_set_font(Font6);
draw_set_colour(generation > 5 ? _gold : _muted);
draw_text(102, 88, generation > 5 ? "저마찰 모드" : "표준 마찰");

// Card 2: one unambiguous state label.
var _state_text = "배치 준비";
var _state_colour = _gold;
if (battle_ready) {
    switch (state) {
        case BattleState.WAIT_TURN:
            _state_text = "턴 전환";
            break;
        case BattleState.PLAYER_INPUT:
            _state_text = "내 턴";
            _state_colour = _cyan;
            break;
        case BattleState.ENEMY_ACTION:
            _state_text = "상대 턴";
            _state_colour = _coral;
            break;
        case BattleState.MOVING:
            _state_text = "이동 중";
            break;
        case BattleState.END_TURN:
            _state_text = "정산 중";
            break;
    }
}

ui_draw_panel(196, 16, 406, 106, 10, _state_colour);
draw_set_font(Font6);
draw_set_colour(_muted);
draw_text(301, 33, "현재 상태");
draw_set_font(Font5);
draw_set_colour(_state_colour);
draw_text_transformed(301, 70, _state_text, 1.25, 1.25, 0);

// Card 3: both teams remain visible in setup and combat.
ui_draw_panel(418, 16, 606, 106, 10, _cyan);
draw_set_font(Font6);
draw_set_colour(_muted);
draw_text(512, 33, battle_ready ? "생존" : "배치 현황");
draw_set_colour(_divider);
draw_line(512, 48, 512, 94);

draw_set_font(Font6);
draw_set_colour(_cyan);
draw_text(466, 56, "내 팀");
draw_set_font(Font5);
draw_text_transformed(466, 79, string(_player_count) + (battle_ready ? "" : "/3"), 1.15, 1.15, 0);

draw_set_font(Font6);
draw_set_colour(_coral);
draw_text(558, 56, "상대");
draw_set_font(Font5);
draw_text_transformed(558, 79, string(_enemy_count), 1.15, 1.15, 0);

// Card 4: explicit turn queue. Cards are ordered left to right from NOW.
ui_draw_panel(618, 16, 940, 106, 10, _gold);
draw_set_halign(fa_left);
draw_set_font(Font6);
draw_set_colour(_muted);
draw_text(634, 33, battle_ready ? "턴 순서  ·  왼쪽부터 진행" : "전투 시작 조건");

if (!battle_ready) {
    draw_set_font(Font5);
    draw_set_colour(_ivory);
    draw_set_valign(fa_middle);
    draw_text(634, 74, "팀 배치 후 START");
} else {
    var _ball_count = array_length(balls);
    if (_ball_count <= 0) {
        draw_set_font(Font5);
        draw_set_colour(_muted);
        draw_text(634, 74, "순서 계산 중...");
    } else {
        var _start_index = clamp(turn_index, 0, _ball_count - 1);
        var _visible_count = min(7, _ball_count - _start_index);
        for (var _queue_i = 0; _queue_i < _visible_count; _queue_i++) {
            var _ball = balls[_start_index + _queue_i];
            if (!instance_exists(_ball)) continue;

            var _token_x = 646 + _queue_i * 42;
            var _team_colour = team_is_enemy(_ball.owner) ? _coral : _cyan;
            draw_set_colour(make_colour_rgb(13, 24, 37));
            draw_roundrect_ext(_token_x, 46, _token_x + 34, 96, 6, 6, false);
            draw_set_colour(_queue_i == 0 ? _gold : _divider);
            draw_roundrect_ext(_token_x, 46, _token_x + 34, 96, 6, 6, true);
            var _queue_scale = (40 / sprite_get_width(_ball.sprite_index)) * 0.52;
            draw_sprite_ext(_ball.sprite_index, _ball.image_index, _token_x + 17, 67, _queue_scale, _queue_scale, 0, c_white, 1);
            draw_set_colour(_team_colour);
            draw_roundrect_ext(_token_x + 5, 89, _token_x + 29, 93, 2, 2, false);

            if (_queue_i == 0) {
                ui_draw_diamond(_token_x + 17, 43, 4, _gold, true);
            }
        }
    }
}

// Right command rail labels. Interactive icons are regular room instances.
draw_set_font(Font5);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_colour(_ivory);
draw_text(992, 792, "지닌 포켓몬");

var _flying_available = instance_exists(obj_flying) && obj_flying.is_active;
if (_flying_available) {
    draw_text(992, 682, "공중날기");
}

// Bottom information dock.
ui_draw_panel(20, _gui_h - 82, 316, _gui_h - 18, 10, _cyan);
draw_set_halign(fa_left);
draw_set_font(Font6);
draw_set_colour(_muted);
draw_text(40, _gui_h - 60, "STAGE");
draw_set_font(Font5);
draw_set_colour(_ivory);
draw_text(40, _gui_h - 35, global.stage_display_text);

ui_draw_panel(646, _gui_h - 82, 940, _gui_h - 18, 10, _gold);
draw_set_font(Font6);
draw_set_colour(_muted);
draw_text(666, _gui_h - 60, "VOLUME");
var _volume_x = volume_bar_x;
var _volume_y = _gui_h - 57;
var _volume_w = volume_bar_width;
var _volume_h = volume_bar_height;
var _volume_mouse_x = device_mouse_x_to_gui(0);
var _volume_mouse_y = device_mouse_y_to_gui(0);
var _volume_hover = point_in_rectangle(
    _volume_mouse_x, _volume_mouse_y,
    _volume_x - 6, _volume_y - 8,
    _volume_x + _volume_w + 6, _volume_y + _volume_h + 8
);
var _volume_accent = (_volume_hover || volume_dragging) ? _ivory : _gold;
draw_set_colour(make_colour_rgb(47, 58, 65));
draw_roundrect_ext(_volume_x, _volume_y, _volume_x + _volume_w, _volume_y + _volume_h, 5, 5, false);
draw_set_colour(_volume_accent);
draw_roundrect_ext(_volume_x, _volume_y, _volume_x + _volume_w * global.master_volume, _volume_y + _volume_h, 5, 5, false);
draw_circle(_volume_x + _volume_w * global.master_volume, _volume_y + _volume_h * 0.5, _volume_hover || volume_dragging ? 7 : 5, false);
draw_set_halign(fa_right);
draw_set_font(Font5);
draw_set_colour(_ivory);
draw_text(910, _gui_h - 35, string(round(global.master_volume * 100)) + "%");

// End-state modal.
if (state == BattleState.ENEMY_WIN || state == BattleState.PLAYER_WIN) {
    draw_set_alpha(0.72);
    draw_set_colour(ui_colour("ink"));
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1);

    var _result_colour = state == BattleState.PLAYER_WIN ? _cyan : _coral;
    ui_draw_panel(210, 300, 750, 660, 18, _result_colour);
    ui_draw_diamond(480, 362, 18, _result_colour, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(Font5);
    draw_set_colour(_ivory);
    draw_text_transformed(480, 455, state == BattleState.PLAYER_WIN ? "VICTORY" : "DEFEAT", 3.2, 3.2, 0);
    draw_set_font(Font5);
    draw_set_colour(_muted);
    draw_text(480, 535, state == BattleState.PLAYER_WIN ? "STAGE CLEARED" : "CLICK TO RETRY");

    if (state == BattleState.ENEMY_WIN) {
        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);
        if (point_in_rectangle(_mouse_x, _mouse_y, 210, 300, 750, 660)) {
            window_set_cursor(cr_handpoint);
            if (mouse_check_button_pressed(mb_left)) room_goto(Room1);
        }
    }
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
