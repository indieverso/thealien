extends Node

var _username : String
var _password : String

var network : NetworkedMultiplayerENet
var gateway_api

export var gatewayserver_ip : String = "localhost"
export var gatewayserver_port : int = 1910

signal authenticating
signal login_succeeded
signal login_failed


func _process(delta: float) -> void:
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()


func login(username: String, password: String) -> void:
	_username = username
	_password = password
	
	connect_to_server()


func connect_to_server() -> void:
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	network.create_client(gatewayserver_ip, gatewayserver_port)
	set_custom_multiplayer(gateway_api)

	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("connection_failed", self, "_on_connection_failed")


func _on_connection_succeeded() -> void:
	print("Succesfully connected to gateway server.")
	emit_signal("authenticating")
	authenticate()


func _on_connection_failed() -> void:
	print("Failed to connected to gateway server.")
	emit_signal("login_failed")


func authenticate() -> void:
	print_debug("Requesting authentication through Gateway")
	rpc_id(1, "authenticate", _username, _password)
	_username = ""
	_password = ""


remote func authenticate_reponse(response) -> void:
	print_debug("Recieving authentication response from Gateway")
	
	network.disconnect("connection_succeeded", self, "_on_connection_succeeded")
	network.disconnect("connection_failed", self, "_on_connection_failed")
	
	if response:
		emit_signal("login_succeeded")
		return
		
	emit_signal("login_failed")
