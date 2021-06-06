tool
extends Node2D
class_name Effect


export(Vector2) var distance: Vector2 = Vector2(0, -50)
export(float) var time: float = .7
export(Texture) var texture: Texture = preload("res://Things/Effect/heal_effect.png")


onready var _tween: Tween = $Tween
onready var _sprite: Sprite = $Sprite
onready var _label: Label = $CenterContainer/Label


func _ready() -> void:
	modulate.a = 0
	_sprite.texture = texture


func play(value: int):
	if value == 0:
		_label.text = str(0)
	elif value < 0:
		_label.text = str(value)
	else:
		_label.text = "+" + str(value)

	_tween.interpolate_property(self, "modulate:a", 0, 1, time/2)
	_tween.interpolate_property(_sprite, "position", -distance, distance, time)
	_tween.interpolate_property(self, "modulate:a", 1, 0, .2, Tween.TRANS_SINE, Tween.EASE_OUT, time)
	_tween.start()
