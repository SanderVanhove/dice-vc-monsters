extends Control


func _on_RollButton_pressed() -> void:
	$ClickAudio.play()
	get_tree().change_scene("res://Screens/Main/Main.tscn")
