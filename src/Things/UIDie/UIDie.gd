extends CenterContainer
class_name UIDie

signal clicked(UIDie)


export(Enums.DieType) var type = Enums.DieType.SWORD


onready var _sword_icon: TextureRect = $SwordIcon
onready var _health_icon: TextureRect = $HealthIcon
onready var _shield_icon: TextureRect = $ShieldIcon


func _ready() -> void:
	_sword_icon.visible = false
	_health_icon.visible = false
	_shield_icon.visible = false

	match type:
		Enums.DieType.SWORD:
			_sword_icon.visible = true
		Enums.DieType.SHIELD:
			_shield_icon.visible = true
		Enums.DieType.HEALTH:
			_health_icon.visible = true


func _on_Border_gui_input(event: InputEvent) -> void:
	if event as InputEventMouseButton and not event.is_pressed():
		emit_signal("clicked", self)
