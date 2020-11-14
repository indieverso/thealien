extends Spatial
class_name Mannequiny
# Controls the animation tree's transitions for this animated character.

# It has a signal connected to the player state machine, and uses the resulting
# state names to translate them into the states for the animation tree.

enum States { IDLE, RUN, AIR, LAND }

#onready var animation_tree: AnimationTree = $AnimationTree
#onready var _playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

var move_direction := Vector3.ZERO setget set_move_direction
var is_moving := false setget set_is_moving


func _ready() -> void:
#	animation_tree.active = true
	pass


func set_move_direction(direction: Vector3) -> void:
	move_direction = direction
#	animation_tree["parameters/move_ground/blend_position"] = direction.length()


func set_is_moving(value: bool) -> void:
	is_moving = value
#	animation_tree["parameters/conditions/is_moving"] = value


func transition_to(state_id: int) -> void:
	match state_id:
		States.IDLE:
			print_debug("travel to idle")
#			_playback.travel("idle")
		States.LAND:
			print_debug("travel to land")
#			_playback.travel("land")
		States.RUN:
			print_debug("travel to ground")
#			_playback.travel("move_ground")
		States.AIR:
			print_debug("travel to jump")
#			_playback.travel("jump")
		_:
			pass
#			_playback.travel("idle")
