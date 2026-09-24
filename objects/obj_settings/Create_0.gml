depth = -2;
if (instance_number(object_index) > 1) {
    instance_destroy();
    exit;
}

settings_opened = false;
modal_open_guard = false;
volume_dragging = false;
volume_bar_width = 320;
volume_bar_height = 14;

// Occupy the former type-chart button position.
x = room_width - 72;
y = 24;
