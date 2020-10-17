extends Control

onready var game_name_input : = $MainContainer/VBoxContainer/CreateGame/GridContainer/GameNameInput


func _ready() -> void:
	game_name_input.text = "Player's server"


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://src/Scenes/Main.tscn")


func _on_StartGameButton_pressed() -> void:
	var game_name : String = game_name_input.text
	GameServer.create_game(game_name)
