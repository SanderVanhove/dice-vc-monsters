tool
extends Node2D
class_name Enemy


var enemy_definition: EnemyDefinition = preload("res://Things/Enemy/skully_boy.tres")


onready var _sprite: Sprite = $Visual/Sprite
onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	load_enemy(enemy_definition)


func load_enemy(new_enemy_def: EnemyDefinition):
	enemy_definition = new_enemy_def
	_sprite.texture = enemy_definition.sprite


func play_damage_animation():
	_animation_player.play("damage")


func play_attack_animation():
	_animation_player.play("attack")
