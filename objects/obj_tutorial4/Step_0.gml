if (!instance_exists(obj_tutorial3) && obj_controller.battle_ready) {
    guide_age++;
    if (guide_age >= 120 && obj_controller.state == BattleState.PLAYER_INPUT) {
        // Keep step 4 visible while step 5 is introduced. Step 5 owns the
        // shared dismissal once the player has completed the first shot.
        next_guide_ready = true;
    }
}
