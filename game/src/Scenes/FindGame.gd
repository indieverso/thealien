extends Control


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://src/Scenes/Main.tscn")


func _on_CreateGameButton_pressed() -> void:
	get_tree().change_scene("res://src/Scenes/CreateGame.tscn")


func _on_RefreshButton_pressed() -> void:
	print_debug("Refreshing server list")
