extends Modal


onready var _twitter_link: Label = $CenterContainer/NinePatchRect/CenterContainer2/HBoxContainer/Label2


func _on_Label2_gui_input(event: InputEvent) -> void:
	if event as InputEventMouseButton and not event.is_pressed():
		OS.shell_open("https://twitter.com/SanderVhove")


func _on_Modal_open() -> void:
	_twitter_link.mouse_filter = Control.MOUSE_FILTER_STOP
