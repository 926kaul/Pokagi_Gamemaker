// Rendering is centralized in obj_controller's existing Draw GUI event.
exit;

if(!obj_controller.selection_done){
    var _all_caught = true;
    for (var i = 0; i < 150; i++) { 
        if (obj_mypokemon.my_pokes[i] != 1) {
            _all_caught = false;
            break; 
        }
    }

    var _target_text = text_string;
    var _title = "첫 파트너";
    var _hint = "포켓몬을 클릭해 선택";
    if (_all_caught) {
        _target_text = text_string_dex_end;
        _title = "도감 완성";
        _hint = "";
    } else if (obj_mypokemon.my_pokes[149] == 1) {
        _target_text = text_string_real_end;
        _title = "전설이 된 트레이너";
        _hint = "";
    } else if (global.endclear) {
        _target_text = text_string_end;
        _title = "챔피언";
        _hint = "";
    }

    // All three starters are equal choices; highlight every selectable icon.
    with (obj_ball) {
        if (owner == "none" || owner == Team.NONE) {
            ui_draw_tutorial_focus(x, y, ui_colour("gold"));
        }
    }

    ui_draw_tutorial_bubble(250, 610, 460, 154, 1, _title, _target_text, _hint,
        global.board.center_x, global.board.center_y, ui_colour("gold"), false);
}
