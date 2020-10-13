extends Node


var _game_owner : int


func init(game_owner: int) -> void:
	_game_owner = game_owner


func get_players():
	var players = []
	for p in get_children():
		# @TODO Find a better way to keep all the player serialization in one place
		players.append({
			"id": int(p.name)
		})
	return players


func to_response():
	return {
		"name": name, 
		"players": get_players(),
		"num_players": get_child_count(), 
		"max_players": 10, 
		"mode": "default"
	}
