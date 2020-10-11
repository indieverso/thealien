extends Control


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://src/Scenes/Main.tscn")


func _on_StartGameButton_pressed() -> void:
	print_debug("Starting the game room")
