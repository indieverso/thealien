extends Control


onready var server_list : = $MainContainer/VBoxContainer/ServerList/HBoxContainer/VBoxContainer


func _ready() -> void:
	GameServer.connect("game_list_updated", self, "_on_game_list_updated")
	list_games()


func list_games() -> void:
	GameServer.list_games()


func clean_list_games() -> void:
	for node in server_list.get_children():
		server_list.remove_child(node)
		node.queue_free()


func _on_game_list_updated(games) -> void:
	clean_list_games()
	if games:
		for game in games:
			var list_item : = preload("res://src/UI/SeverListItem.tscn").instance()
			list_item.get_node("ServerName").text = game.name
			list_item.get_node("NumPlayers").text = str(game.players) + "/" + str(game.max_players)
			list_item.get_node("GameMode").text = str(game.mode)
			server_list.add_child(list_item)


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://src/Scenes/Main.tscn")


func _on_CreateGameButton_pressed() -> void:
	get_tree().change_scene("res://src/Scenes/CreateGame.tscn")


func _on_RefreshButton_pressed() -> void:
	print_debug("Refreshing server list")
