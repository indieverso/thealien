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
		lobby.remove_child(player)
		game.add_child(player)
		response = {
			"name": game.name, 
			"players": game.get_child_count(), 
			"max_players": 10, 
			"mode": "default"}
	
	rpc_id(player_id, "create_game_response", response)


remote func list_games() -> void:
	print("Listing games")
	var player_id : = get_tree().get_rpc_sender_id()
	
	var game_list = []
	for game in games.get_children():
		game_list.append({"name": game.name, "players": 1, "max_players": 10, "mode": "default"})
	
	rpc_id(player_id, "list_games_response", game_list)
