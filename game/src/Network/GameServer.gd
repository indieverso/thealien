extends Node


var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var my_info : = {"username": "Player"}
var my_game

export var gameserver_ip : String = "localhost"
export var gameserver_port : int = 1909

signal game_list_updated
signal new_player_joined
signal player_position_updated


func connect_to_server() -> void:
	print_debug("Connecting to the game server.")
	network.create_client(gameserver_ip, gameserver_port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("connection_failed", self, "_on_connection_failed")


func _on_connection_succeeded() -> void:
	print("Succesfully connected to the game server.")
	# TODO Dispatch an event instead using the code down bellow
	get_tree().change_scene("res://src/Scenes/Main.tscn")


func _on_connection_failed() -> void:
	print("Failed to connected to the game server.")


func create_game(game_name: String) -> void:
	print_debug("Creating a game room")
	rpc_id(1, "create_game", game_name)


remote func create_game_response(response) -> void:
	if not response:
		print_debug("Failed to create the game")
		return
	my_game = response
	get_tree().change_scene("res://src/Scenes/Game.tscn")


func list_games():
	rpc_id(1, "list_games")


remote func list_games_response(games):
	emit_signal("game_list_updated", games)


func join_game(game_name: String) -> void:
	rpc_id(1, "join_game", game_name)


remote func join_game_response(response) -> void:
	if not response:
		print_debug("Failt to join the game")
		return
	my_game = response
	get_tree().change_scene("res://src/Scenes/Game.tscn")


remote func new_player_joined(player_info) -> void:
	if player_info.id == get_tree().get_network_unique_id():
		return
	emit_signal("new_player_joined", player_info)


func update_player_position(position: Vector2) -> void:
	rpc_unreliable_id(1, "update_player_position", position)


remote func update_player_position_response(player_id: int, position: Vector2) -> void:
	emit_signal("player_position_updated", player_id, position)
