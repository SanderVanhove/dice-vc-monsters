extends CenterContainer
class_name HealthBar


const CHANGE_TIME: float = .4


export(int) var max_value: int setget set_max_value


onready var _progress_bar: ProgressBar = $ProgressBar
onready var _label: Label = $Label
onready var _tween: Tween = $Tween


func set_max_value(new_max_value: int):
	max_value = new_max_value

	if not is_instance_valid(_progress_bar):
		return

	_progress_bar.max_value = max_value
	_progress_bar.value = 0
	change_value(max_value)


func change_value(value: int):
	var current_value = _progress_bar.value

	_tween.interpolate_property(_progress_bar, "value", current_value, value, CHANGE_TIME)
	_tween.start()

	var label_value = _progress_bar.value
	while label_value != value:
		label_value += 1 if current_value < value else -1
		_label.text = str(label_value) + " / " + str(max_value)
		yield(get_tree().create_timer(CHANGE_TIME / (current_value - value)), "timeout")

