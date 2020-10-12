extends Node


var _game_owner : int


func init(game_owner: int) -> void:
	_game_owner = game_owner


func to_response():
	return {
		"name": name, 
		"num_players": get_child_count(), 
		"max_players": 10, 
		"mode": "default"
	}
