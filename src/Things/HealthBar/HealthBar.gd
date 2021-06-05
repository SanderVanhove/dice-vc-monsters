extends CenterContainer


export(int) var max_value: int = 10


onready var _progress_bar: ProgressBar = $ProgressBar
onready var _label: Label = $Label


func _ready() -> void:
	_progress_bar.max_value = max_value
	change_value(max_value)


func change_value(value: int):
	_label.text = str(value) + " / " + str(max_value)
	_progress_bar.value = value
