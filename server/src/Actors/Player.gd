extends KinematicBody
class_name Player

enum {
	IDLE,
	MOVE
}

var player_info : = {
	"id": 0,
	"name": "???",
}

var current_state : = IDLE
var velocity : Vector3 = Vector3.ZERO

puppet var puppet_position : Vector3
puppet var puppet_velocity : Vector3 = Vector3.ZERO


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	global_transform.origin = puppet_position
	velocity = puppet_velocity
	
	velocity = move_and_slide(velocity)
	puppet_position = global_transform.origin


func serialize():
	return {
		"id": int(name),
		"name": name,
	}
