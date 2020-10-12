extends Node


func _ready() -> void:
	spawn_player(get_tree().get_network_unique_id())
	GameServer.connect("new_player_joined", self, "_on_new_player_joined")
	# GameServer.connect("new_player_left", self, "_on_new_player_left")


func spawn_player(player_id: int) -> void:
	var player : KinematicBody2D = preload("res://src/Actors/Player.tscn").instance()
	player.name = str(player_id)
	player.set_network_master(player_id)
	player.position = Vector2(650, 350)
	$World.add_child(player)


func _on_new_player_joined(player_id: int) -> void:
	print_debug("Spawning " + str(player_id))
	spawn_player(player_id)


func _on_new_player_left(player_id: int) -> void:
	print_debug("Removing " + str(player_id))
	var player : = get_node(str(player_id))	
	if player:
		player.queue_free()
