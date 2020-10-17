extends KinematicBody2D
class_name Player

var player_info : = {
	"id": 0,
	"name": "???",
}


func serialize():
	return {
		"id": int(name),
		"name": name,
	}
