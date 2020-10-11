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


func _on_peer_disconnected(player_id: int) -> void:
	print("Player " + str(player_id) + " disconnected.")


func register_player(player_id: int) -> void:
	var player : Node = Node.new()
	player.name = str(player_id)
	lobby.add_child(player)


func unregister_player(player_id: int) -> void:
	var player : Node = lobby.get_node(str(player_id))
	if player:
		player.queue_free()


remote func create_game(name: String) -> void:
	print("Creating game " + name)
	var game : = preload("res://src/Game/Game.tscn").instance()
	game.name = name
	game.init()
	games.add_child(game)
