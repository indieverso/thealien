extends Node


var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()

export var port : int = 1909


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
