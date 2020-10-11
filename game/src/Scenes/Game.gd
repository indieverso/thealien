extends Node


func _ready() -> void:
	GameServer.network.connect("peer_connected", self, "_on_peer_connected")
	GameServer.network.connect("peer_disconnected", self, "_on_peer_disconnected")


func spawn_player(player_id: int) -> void:
	var player : KinematicBody2D = preload("res://src/Actors/Player.tscn").instance()
	player.name = str(player_id)
	player.set_network_master(player_id)
	#player.position = Vector2.ZERO
	$World.add_child(player)


func _on_peer_connected(player_id: int) -> void:
	print_debug("Spawning " + str(player_id))
	spawn_player(player_id)


func _on_peer_disconnected(player_id: int) -> void:
	var player : = get_node(str(player_id))	
	if player:
		print_debug("Removing " + str(player_id))
		player.queue_free()
