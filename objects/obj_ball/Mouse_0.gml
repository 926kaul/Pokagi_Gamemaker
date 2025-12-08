if (owner == "none") {
    owner = "player";
    global.player_choice = pokemon_id;

    with (obj_controller) {
        selection_done = true;
    }
}