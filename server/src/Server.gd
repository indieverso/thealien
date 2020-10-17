extends Node


var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()

export var port : int = 1909

onready var Lobby : = $Lobby
onready var Games : = $Games

signal player_registred
signal player_unregistred


func _ready() -> void:
	start_server()


func start_server() -> void:
	network.create_server(port)
	get_tree().set_network_peer(network)
	
	print("Game server is runnning on " + str(port) + " port.")
	
	network.connect("peer_connected", self, "_on_peer_connected")
	network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(player_id: int) -> void:
	print("Player " + str(player_id) + " connected.")
	register_player(player_id)


func _on_peer_disconnected(player_id: int) -> void:
	print("Player " + str(player_id) + " disconnected.")
	unregister_player(player_id)


##################################
## Player Controller
##################################


func register_player(player_id: int) -> void:
	var player : Node = Node.new()
	player.name = str(player_id)
	Lobby.add_child(player)
	emit_signal("player_registred", player_id)


func unregister_player(player_id: int) -> void:
	var player : = Lobby.get_node(str(player_id))
	if player:
		player.queue_free()
		emit_signal("player_unregistred", player_id)


##################################
## GAME CONTROLLER
##################################


func _add_player_to_game(player, game) -> void:
	Lobby.remove_child(player)
	game.add_player(player)


remote func create_game(game_name: String) -> void:
	print("Creating game " + game_name)
	var player_id : = get_tree().get_rpc_sender_id()
	
	var game : = preload("res://src/Game/Game.tscn").instance()
	game.name = game_name
	game.init(player_id)
	
	Games.add_child(game)
	
	var response = ""
		
	var player = Lobby.get_node(str(player_id))
	if player and game:
		_add_player_to_game(player, game)
		response = game.serialize()

	rpc_id(player_id, "create_game_response", response)


remote func list_games() -> void:
	print("Listing games")
	var player_id : = get_tree().get_rpc_sender_id()
	
	var game_list = []
	for game in Games.get_children():
		game_list.append(game.serialize())
	
	rpc_id(player_id, "list_games_response", game_list)


remote func join_game(game_name: String) -> void:
	var player_id : = get_tree().get_rpc_sender_id()
	
	print("Player " + str(player_id) + " joining game " + game_name)
	
	var response = ""
	
	var game : = Games.get_node(game_name)
	var player = Lobby.get_node(str(player_id))
	if game and player:
		_add_player_to_game(player, game)
		response = game.serialize()
		
		for p in game.get_children():
			if int(p.name) != player_id:
				rpc_id(int(p.name), "player_joined_game", game_name, p.serialize())
	
	rpc_id(player_id, "join_game_response", response)
