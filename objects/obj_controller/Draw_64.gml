// Remaster HUD: independent cards keep every battle concept readable.
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _ivory = ui_colour("ivory");
var _ink = ui_colour("ink");
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
var _low_friction = generation >= low_friction_round;
var _round_accent = _low_friction ? _coral : _gold;
ui_draw_panel(340, 16, 504, 106, 10, _round_accent);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(Font5);
draw_set_colour(_ivory);
draw_text_transformed(422, 52, "라운드 " + string(generation), 1.15, 1.15, 0);
draw_set_font(Font6);
if (_low_friction) {
    draw_set_colour(_coral);
    draw_circle(365, 88, 9, false);
    draw_set_colour(_ink);
    draw_text(365, 89, "!");
    draw_set_colour(_coral);
    draw_text(431, 88, "저마찰 환경");
} else {
    draw_set_colour(_muted);
    draw_text(422, 88, "표준 마찰");
}

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

ui_draw_panel(516, 16, 726, 106, 10, _state_colour);
draw_set_font(Font6);
draw_set_colour(_muted);
draw_text(621, 33, "현재 상태");
draw_set_font(Font5);
draw_set_colour(_state_colour);
draw_text_transformed(621, 70, _state_text, 1.25, 1.25, 0);

// Card 3: both teams remain visible in setup and combat.
ui_draw_panel(738, 16, 926, 106, 10, _cyan);
draw_set_font(Font6);
draw_set_colour(_muted);
draw_text(832, 33, battle_ready ? "생존" : "배치 현황");
draw_set_colour(_divider);
draw_line(832, 48, 832, 94);

draw_set_font(Font6);
draw_set_colour(_cyan);
draw_text(786, 56, "내 팀");
draw_set_font(Font5);
draw_text_transformed(786, 79, string(_player_count) + (battle_ready ? "" : "/3"), 1.15, 1.15, 0);

draw_set_font(Font6);
draw_set_colour(_coral);
draw_text(878, 56, "상대");
draw_set_font(Font5);
draw_text_transformed(878, 79, string(_enemy_count), 1.15, 1.15, 0);

// Card 4: explicit turn queue. Cards are ordered left to right from NOW.
ui_draw_panel(938, 16, 1260, 106, 10, _gold);
draw_set_halign(fa_left);
draw_set_font(Font6);
draw_set_colour(_muted);
draw_text(954, 33, battle_ready ? "턴 순서  ·  왼쪽부터 진행" : "전투 시작 조건");

if (!battle_ready) {
    draw_set_font(Font5);
    draw_set_colour(_ivory);
    draw_set_valign(fa_middle);
    draw_text(954, 74, "팀 배치 후 START");
} else {
    var _ball_count = array_length(balls);
    if (_ball_count <= 0) {
        draw_set_font(Font5);
        draw_set_colour(_muted);
        draw_text(954, 74, "순서 계산 중...");
    } else {
        var _start_index = clamp(turn_index, 0, _ball_count - 1);
        var _visible_count = min(7, _ball_count - _start_index);
        for (var _queue_i = 0; _queue_i < _visible_count; _queue_i++) {
            var _ball = balls[_start_index + _queue_i];
            if (!instance_exists(_ball)) continue;

            var _token_x = 966 + _queue_i * 42;
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
draw_set_colour(instance_exists(obj_tutorial1) ? _muted : _ivory);
draw_text(room_width - 288, 792, "지닌 포켓몬");

var _flying_available = instance_exists(obj_flying) && obj_flying.is_active;
if (_flying_available) {
    draw_text(room_width - 288, 682, "공중날기");
}

// Bottom information dock.
ui_draw_panel(340, _gui_h - 82, 636, _gui_h - 18, 10, _cyan);
draw_set_halign(fa_left);
draw_set_font(Font6);
draw_set_colour(_muted);
draw_text(360, _gui_h - 60, "STAGE");
draw_set_font(Font5);
draw_set_colour(_ivory);
draw_text(360, _gui_h - 35, global.stage_display_text);

// End-state modal.
if (state == BattleState.ENEMY_WIN || state == BattleState.PLAYER_WIN) {
    draw_set_alpha(0.72);
    draw_set_colour(ui_colour("ink"));
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1);

    var _result_colour = state == BattleState.PLAYER_WIN ? _cyan : _coral;
    ui_draw_panel(530, 300, 1070, 660, 18, _result_colour);
    ui_draw_diamond(800, 362, 18, _result_colour, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(Font5);
    draw_set_colour(_ivory);
    draw_text_transformed(800, 455, state == BattleState.PLAYER_WIN ? "VICTORY" : "DEFEAT", 3.2, 3.2, 0);
    draw_set_font(Font5);
    draw_set_colour(_muted);
    draw_text(800, 535, state == BattleState.PLAYER_WIN ? "STAGE CLEARED" : "CLICK TO RETRY");

    if (state == BattleState.ENEMY_WIN) {
        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);
        if (point_in_rectangle(_mouse_x, _mouse_y, 530, 300, 1070, 660)) {
            window_set_cursor(cr_handpoint);
            if (mouse_check_button_pressed(mb_left)) room_goto(Room1);
        }
    }
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// The left monitor inspects both field pieces and icons in the collection screen.
ui_draw_pokemon_hover_panel();

// Draw tutorials last so they remain readable above every HUD component.
ui_draw_tutorial_overlay();
