extends Node


var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var my_info : = {"username": "Player"}
var my_game

export var gameserver_ip : String = "localhost"
export var gameserver_port : int = 1909

signal game_list_updated


func connect_to_server() -> void:
	print_debug("Connecting to the game server.")
	network.create_client(gameserver_ip, gameserver_port)
	get_tree().set_network_peer(network)
	
	network.connect("peer_connected", self, "_on_peer_connected")
	network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(player_id: int) -> void:
	print_debug("Player " + str(player_id) + " connected.")
	# FIXME I do have a bug here. The player_id is not the correct one
	my_info.id = player_id
	# TODO Dispatch an event instead using the code down bellow
	get_tree().change_scene("res://src/Scenes/Main.tscn")


func _on_peer_disconnected(player_id: int) -> void:
	print_debug("Player " + str(player_id) + " disconnected")


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
