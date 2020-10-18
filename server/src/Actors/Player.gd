extends KinematicBody2D
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
var velocity : Vector2 = Vector2.ZERO

puppet var puppet_position : Vector2
puppet var puppet_velocity : Vector2 = Vector2.ZERO


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	position = puppet_position
	velocity = puppet_velocity
	
	velocity = move_and_slide(velocity)
	puppet_position = position


func serialize():
	return {
		"id": int(name),
		"name": name,
	}
