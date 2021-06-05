extends Node2D


onready var _shaders: Control = $CanvasLayer/Shaders

func _ready() -> void:
	_shaders.visible = true
