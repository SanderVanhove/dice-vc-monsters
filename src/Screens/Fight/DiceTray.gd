extends Node2D
class_name DiceTray


onready var _dice: Node2D = $Dice
onready var _center: Node2D = $Center


func _ready() -> void:
	for die in _dice.get_children():
		die.throw_target = _center.position


func add_die(die: Die):
	_dice.add_child(die)
	die.throw(false)
	die.throw_target = _center.position
