extends Node


var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()

export var port : int = 1909

onready var lobby : = $Lobby
onready var games : = $Games


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


func register_player(player_id: int) -> void:
	var player : Node = Node.new()
	player.name = str(player_id)
	lobby.add_child(player)


func unregister_player(player_id: int) -> void:
	var player : = lobby.get_node(str(player_id))
	if player:
		player.queue_free()


func _add_player_to_game(player, game) -> void:
	lobby.remove_child(player)
	game.add_child(player)


remote func create_game(game_name: String) -> void:
	print("Creating game " + game_name)
	var player_id : = get_tree().get_rpc_sender_id()
	
	var game : = preload("res://src/Game/Game.tscn").instance()
	game.name = game_name
	game.init(player_id)
	games.add_child(game)
	
	var response = ""
		
	var player = lobby.get_node(str(player_id))
	if player:
		_add_player_to_game(player, game)
		response = game.to_response()

	rpc_id(player_id, "create_game_response", response)


remote func list_games() -> void:
	print("Listing games")
	var player_id : = get_tree().get_rpc_sender_id()
	
	var game_list = []
	for game in games.get_children():
		game_list.append(game.to_response())
	
	rpc_id(player_id, "list_games_response", game_list)


remote func join_game(game_name: String) -> void:
	var response = ""
	var player_id : = get_tree().get_rpc_sender_id()
	
	print("Player " + str(player_id) + " joining game " + game_name)
	
	var game : = games.get_node(game_name)
	var player = lobby.get_node(str(player_id))
	if game and player:
		_add_player_to_game(player, game)
		response = game.to_response()
		
		for p in game.get_children():
			# @TODO Find a better way to keep all the player serialization in one place
			rpc_id(int(p.name), "new_player_joined", {"id": player_id})
	
	rpc_id(player_id, "join_game_response", response)
