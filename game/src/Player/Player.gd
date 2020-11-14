tool
class_name Player
extends KinematicBody
# Helper class for the Player scene's scripts to be able to have access to the
# camera and its orientation.

var player_info : = {}

export var is_alive : bool = true
export var is_alien : bool = false

puppet var puppet_position : Vector3
puppet var puppet_velocity : Vector3 = Vector3.ZERO

onready var camera := $CameraGimbal
onready var skin : Mannequiny = $Mannequiny
onready var state_machine: StateMachine = $StateMachine


func _get_configuration_warning() -> String:
	return "Missing camera node" if not camera else ""


func init(info) -> void:
	player_info = info
	name = str(player_info.id)	
	global_transform = player_info.position
	set_network_master(player_info.id)


func _ready() -> void:
	pass

#func get_input_direction() -> Vector3:
#	var h_mov : = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#	var v_mov : = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#	return Vector3(h_mov, 0, v_mov).normalized()
#
#
#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("interact"):
#		interactable_area.handle_interact()
#		return
#
#	if event.is_action_pressed("kill"):
#		killable_area.handle_kill()
#		return
#
#	if event.is_action_pressed("toggle_tasks"):
#		print("Toggle tasks")
#		return
#
#	if event.is_action_pressed("use_skill"):
#		print("Use still")
#		return
#
#
#func _physics_process(delta: float) -> void:
#	if not is_network_master():
#		global_transform.origin = puppet_position
#		velocity = puppet_velocity
#
#	match current_state:
#		IDLE:
#			idle_state(delta)
#		MOVE:
#			move_state(delta)
#
#	if is_network_master():
#		velocity = move_and_slide(velocity, Vector3.UP)
#
#		rset_unreliable("puppet_position", global_transform.origin)
#		rset_unreliable("puppet_velocity", velocity)
