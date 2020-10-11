extends Node

var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()

export var authserver_ip : String = "localhost"
export var authserver_port : int = 1911

onready var gateway_server : = get_parent().get_node("Gateway")


func _ready() -> void:
	connect_to_authserver()


func connect_to_authserver() -> void:
	network.create_client(authserver_ip, authserver_port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("connection_failed", self, "_on_connection_failed")


func _on_connection_succeeded() -> void:
	print("Succesfully connected to the authentication server.")


func _on_connection_failed() -> void:
	print("Failed to connected to the authentication server.")


func authenticate(username: String, password: String, player_id: int) -> void:
	print("Sending authentication request to authentication server for " + str(player_id))
	rpc_id(1, "authenticate", username, password, player_id)


remote func authenticate_response(response, player_id: int) -> void:
	print("Results from authentication recieved for " + str(player_id))
	gateway_server.authenticate_response(response, player_id)
