extends Control


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_CreateGameButton_pressed() -> void:
	get_tree().change_scene("res://src/Scenes/CreateGame.tscn")


func _on_FindGameButton_pressed() -> void:
	get_tree().change_scene("res://src/Scenes/FindGame.tscn")
