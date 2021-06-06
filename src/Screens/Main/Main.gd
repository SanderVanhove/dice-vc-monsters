extends Node2D


const TRANSITION_DURATION: float = .5


var LevelSelectClass = preload("res://Screens/LevelSelect/LevelSelect.tscn")
var FightClass = preload("res://Screens/Fight/Fight.tscn")


onready var _level_select: LevelSelect = $SpawnNode/CanvasLayer/LevelSelect
onready var _canvas_layer: CanvasLayer = $SpawnNode/CanvasLayer
onready var _spawn_node: Node2D = $SpawnNode
onready var _tween: Tween = $Tween


var _fight: Fight
var _level: int = 0
var _potential_level: int = 0

func _on_LevelSelect_enemy_selected(enemy: EnemyDefinition, level: int) -> void:
	_potential_level = level

	_fight = FightClass.instance()
	_fight.enemy_definition = enemy
	_fight.connect("hero_died", self, "to_level_select")
	_fight.connect("monster_died", self, "player_won")
	_fight.modulate.a = 0
	if level == 1: _fight.is_tutorial = true
	if level == 3: _fight._add_extra_die = true

	_spawn_node.add_child(_fight)
	_tween.interpolate_property(_level_select, "modulate:a", 1, 0, TRANSITION_DURATION)
	_tween.interpolate_property(_fight, "modulate:a", 0, 1, TRANSITION_DURATION)
	_tween.start()

	yield(_tween, "tween_all_completed")
	_level_select.rect_position.x -= 100000


func player_won():
	_level = _potential_level
	to_level_select()


func to_level_select():
	_level_select.num_defeated_enemies = _level
	_level_select.init()
	_level_select.rect_position.x = 0

	_tween.interpolate_property(_level_select, "modulate:a", 0, 1, TRANSITION_DURATION)
	_tween.interpolate_property(_fight, "modulate:a", 1, 0, TRANSITION_DURATION)
	_tween.start()

	yield(_tween, "tween_all_completed")
	_spawn_node.remove_child(_fight)
