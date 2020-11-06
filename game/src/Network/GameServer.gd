extends Node


var network: NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()

var my_info
var my_game

export var gameserver_ip: String = "localhost"
export var gameserver_port: int = 1909

signal game_list_updated
signal player_joined_game
signal player_left_game


func connect_to_server() -> void:
	print_debug("Connecting to the game server.")
	network.create_client(gameserver_ip, gameserver_port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("connection_failed", self, "_on_connection_failed")


func _on_connection_succeeded() -> void:
	print("Succesfully connected to the game server.")
	
	_load_player_info()
	if not my_info:
		print_debug("Failed to get player info.")
		return
	
	get_tree().change_scene("res://src/Scenes/Main.tscn")


func _on_connection_failed() -> void:
	print("Failed to connected to the game server.")


func _load_player_info() -> void:
	# TODO Load player data from database using jwt token
	my_info = {
		"id": get_tree().get_network_unique_id(),
	}


##################################
## GAME CONTROLLER
##################################


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


remote func player_joined_game(player_info) -> void:
	print(player_info)
	emit_signal("player_joined_game", player_info)
