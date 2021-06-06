extends Control
class_name Modal

signal close


export(String) var title: String
export(String, MULTILINE) var text: String


onready var _tween: Tween = $Tween
onready var _title: Label = $CenterContainer/NinePatchRect/Title
onready var _text: Label = $CenterContainer/NinePatchRect/CenterContainer/Text
onready var _color_rect: ColorRect = $ColorRect


func _ready() -> void:
	modulate.a = 0


func popup():
	_title.text = title
	_text.text = text

	_tween.interpolate_property(self, "modulate:a", 0, 1, .2)
	_tween.start()

	_color_rect.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_color_rect.mouse_filter = Control.MOUSE_FILTER_STOP

	yield(self, "close")

	_tween.interpolate_property(self, "modulate:a", 1, 0, .2)
	_tween.start()

	_color_rect.mouse_default_cursor_shape = Control.CURSOR_ARROW
	_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	yield(_tween, "tween_all_completed")
	queue_free()


func _on_ColorRect_gui_input(event: InputEvent) -> void:
	if event as InputEventMouseButton and not event.is_pressed():
		emit_signal("close")
