extends Node

onready var GameRoom := $GameRoom
onready var World : = $GameRoom/World

func _ready() -> void:
	GameServer.connect("new_player_joined", self, "_on_new_player_joined")
	GameServer.connect("new_player_left", self, "_on_new_player_left")
	_configure_room()


func _configure_room() -> void:
	var game = GameServer.my_game
	GameRoom.name = game.name
	for p in game.players:
		spawn_player(p)


func spawn_player(player_info) -> void:
	var player : = preload("res://src/Actors/Player.tscn").instance()
	player.init(player_info)
	World.add_child(player)


func _on_new_player_joined(player_info) -> void:
	print_debug("Spawning " + str(player_info.id))
	spawn_player(player_info)


func _on_new_player_left(player_id: int) -> void:
	print_debug("Removing " + str(player_id))
	var player : = World.get_node(str(player_id))	
	if player:
		player.queue_free()
