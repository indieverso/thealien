extends KinematicBody
class_name Player

enum {
	IDLE,
	MOVE
}

var player_info : = {}

var current_state : = IDLE
var velocity : Vector3 = Vector3.ZERO

puppet var puppet_position : Vector3
puppet var puppet_velocity : Vector3 = Vector3.ZERO

export var is_alive : bool = true
export var is_alien : bool = false
export var acceleration : float = 600.0
export var max_speed : float = 400.0
export var friction : float = 350.0

# Animation
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var animation_tree : AnimationTree = $AnimationTree
# onready var animation_state : AnimationNodeStateMachine = animation_state.get("parameters/playback")

# Game mechanics
onready var interactable_area : = $InteractableArea
onready var killable_area : = $KillableArea

func init(info) -> void:
	player_info = info
	name = str(player_info.id)	
	global_transform = player_info.position
	set_network_master(player_info.id)
	$CenterContainer/Label.text = player_info.name


func _ready() -> void:
	# animation_tree.active = true
	pass


func get_input_direction() -> Vector3:
	var h_mov : = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var v_mov : = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return Vector3(h_mov, 0, v_mov).normalized()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interactable_area.handle_interact()
		return
	
	if event.is_action_pressed("kill"):
		killable_area.handle_kill()
		return
	
	if event.is_action_pressed("toggle_tasks"):
		print("Toggle tasks")
		return
	
	if event.is_action_pressed("use_skill"):
		print("Use still")
		return


func _physics_process(delta: float) -> void:
	if not is_network_master():
		global_transform.origin = puppet_position
		velocity = puppet_velocity
	
	match current_state:
		IDLE:
			idle_state(delta)
		MOVE:
			move_state(delta)
	
	if is_network_master():
		velocity = move_and_slide(velocity, Vector3.UP)
		
		rset_unreliable("puppet_position", global_transform.origin)
		rset_unreliable("puppet_velocity", velocity)


func idle_state(delta: float) -> void:
	var input_direction = get_input_direction()
	if input_direction != Vector3.ZERO:
		current_state = MOVE
		return
	
	# animation_state.travel("Idle")
	
	if velocity != Vector3.ZERO:
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)


func move_state(delta: float) -> void:
	var input_direction = get_input_direction()
	
	if input_direction != Vector3.ZERO:
		# animation_tree.set("parameters/Idle/blend_position", input_direction)
		# note: must to be done to all states on animation_tree
		
		# animation_tree.travel("Run")
		velocity = velocity.move_toward(
			input_direction * max_speed, 
			acceleration * delta)
	else:
		current_state = IDLE
