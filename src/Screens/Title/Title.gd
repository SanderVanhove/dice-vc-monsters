extends Control


func _on_RollButton_pressed() -> void:
	$ClickAudio.play()
	get_tree().change_scene("res://Screens/Main/Main.tscn")


func _on_Label3_gui_input(event: InputEvent) -> void:
	if event as InputEventMouseButton and not event.is_pressed():
		OS.shell_open("https://twitter.com/SanderVhove")
