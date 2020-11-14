extends KinematicBody
class_name Player

enum {
	IDLE,
	MOVE
}

var player_info : = {
	"id": 0,
	"name": "???",
	"color": Color(0, 0, 0)
}

var current_state : = IDLE
var velocity : Vector3 = Vector3.ZERO

puppet var puppet_transform : Transform
puppet var puppet_velocity : Vector3 = Vector3.ZERO


func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	global_transform = puppet_transform
	velocity = puppet_velocity
	
	velocity = move_and_slide(velocity)
	puppet_transform = global_transform
	puppet_velocity = velocity


func serialize():
	return {
		"id": int(name),
		"name": name,
		"position": global_transform,
		"color": player_info.color,
	}
