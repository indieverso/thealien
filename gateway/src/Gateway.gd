extends Node

var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var gateway_api : = MultiplayerAPI.new()

export var port : int = 1910
export var max_players : int = 100

onready var auth_server : = get_parent().get_node("Authentication")


func _ready() -> void:
	start_server()


func _process(delta: float) -> void:
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()


func start_server() -> void:
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	print("Gateway server is runnning on " + str(port) + " port.")
	
	network.connect("peer_connected", self, "_on_peer_connected")
	network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(player_id: int) -> void:
	print("Player " + str(player_id) + " connected.")


func _on_peer_disconnected(player_id: int) -> void:
	print("Player " + str(player_id) + " disconnected.")


remote func authenticate(username: String, password: String) -> void:
	var player_id : = custom_multiplayer.get_rpc_sender_id()
	print("Login requested for " + str(player_id))
	auth_server.authenticate(username, password, player_id)


func authenticate_response(response, player_id: int) -> void:
	print("Reciving response from authentication server for " + str(player_id))
	rpc_id(player_id, "authenticate_reponse", response)
	network.disconnect_peer(player_id)
