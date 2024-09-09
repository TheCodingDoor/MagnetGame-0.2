extends CanvasLayer

var window_sizes = [Vector2(1024,768),Vector2(1280,1024),Vector2(1366,768),Vector2(1920,1080)]

func _ready():
	$VSyncCheckbox.button_pressed = true if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED else false
	$FullScreenCheckbox.button_pressed = true if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN else false

func _on_v_sync_checkbox_toggled(button_pressed):
	DisplayServer.window_set_vsync_mode(button_pressed)


func _on_v_sync_checkbox_mouse_exited():
	$VSyncCheckbox.release_focus()


func _on_full_screen_checkbox_toggled(button_pressed):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if button_pressed else DisplayServer.WINDOW_MODE_WINDOWED)


func _on_button_pressed():
	DisplayServer.window_set_size(Vector2(1366,768))


func _on_screen_sizes_tab_changed(tab):
	DisplayServer.window_set_size(window_sizes[tab])
