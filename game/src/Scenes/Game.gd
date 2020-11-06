extends Node

onready var GameRoom := $GameRoom
onready var World : = $GameRoom/World
onready var SpawnPoint : = $GameRoom/World/SpawnPoint

func _ready() -> void:
	GameServer.connect("player_joined_game", self, "_on_player_joined_game")
	GameServer.connect("player_left_game", self, "_on_player_left_game")
	_configure_room()

func _configure_room() -> void:
	var game = GameServer.my_game
	GameRoom.name = game.name
	for p in game.players:
		spawn_player(p)


func spawn_player(player_info) -> void:
	var player : = preload("res://src/Actors/Player.tscn").instance()
	player_info.position = SpawnPoint.global_transform
	player.init(player_info)
	World.add_child(player)


func _on_player_joined_game(player_info) -> void:
	print_debug("Spawning " + str(player_info.id))
	spawn_player(player_info)


func _on_player_left_game(player_id: int) -> void:
	print_debug("Removing " + str(player_id))
	var player : = World.get_node(str(player_id))	
	if player:
		player.queue_free()
