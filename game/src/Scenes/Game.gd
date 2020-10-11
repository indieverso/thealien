extends Node


func _ready() -> void:
	spawn_player(get_tree().get_network_unique_id())
	GameServer.network.connect("peer_connected", self, "_on_peer_connected")	
	GameServer.network.connect("peer_disconnected", self, "_on_peer_disconnected")


func spawn_player(player_id: int) -> void:
	var player : KinematicBody2D = preload("res://src/Actors/Player.tscn").instance()
	player.name = str(player_id)
	player.set_network_master(player_id)
	player.position = Vector2(650, 350)
	$World.add_child(player)


func _on_peer_connected(player_id: int) -> void:
	print_debug("Spawning " + str(player_id))
	spawn_player(player_id)


func _on_peer_disconnected(player_id: int) -> void:
	print_debug("Removing " + str(player_id))
	var player : = get_node(str(player_id))	
	if player:
		player.queue_free()
