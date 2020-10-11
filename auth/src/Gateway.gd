extends Node

var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()

export var port : int = 1911
export var max_servers : int = 5


func _ready() -> void:
	start_server()


func start_server() -> void:
	network.create_server(port, max_servers)
	get_tree().set_network_peer(network)
	
	print("Authentication server is runnning on " + str(port) + " port.")
	
	network.connect("peer_connected", self, "_on_peer_connected")
	network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(gateway_id: int) -> void:
	print("Gateway " + str(gateway_id) + " connected.")


func _on_peer_disconnected(gateway_id: int) -> void:
	print("Gateway " + str(gateway_id) + " disconneted.")


remote func authenticate(username: String, password: String, player_id: int) -> void:
	print("Authenticating " + str(player_id))
	var gateway_id = get_tree().get_rpc_sender_id()
		
	var player_store = PlayerStore.new()
	var response = player_store.authenticate(username, password)
	
	rpc_id(gateway_id, "authenticate_response", response, player_id)
