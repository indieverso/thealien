extends Node


func _ready() -> void:
	GameServer.connect("new_player_joined", self, "_on_new_player_joined")
	# GameServer.connect("new_player_left", self, "_on_new_player_left")
	configure_room()


func configure_room() -> void:
	var game = GameServer.my_game
	for p in game.players:
		spawn_player(p)


func spawn_player(player_info) -> void:
	var player : KinematicBody2D = preload("res://src/Actors/Player.tscn").instance()
	player.init(player_info)
	$World.add_child(player)


func _on_new_player_joined(player_info) -> void:
	print_debug("Spawning " + str(player_info.id))
	spawn_player(player_info)


func _on_new_player_left(player_id: int) -> void:
	print_debug("Removing " + str(player_id))
	var player : = get_node(str(player_id))	
	if player:
		player.queue_free()
