extends KinematicBody2D

enum {
	IDLE,
	MOVE
}

var current_state : = IDLE
var velocity : Vector2 = Vector2.ZERO

export var is_alien : bool = false
export var acceleration : float = 600.0
export var max_speed : float = 400.0
export var friction : float = 350.0

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var animation_tree : AnimationTree = $AnimationTree
# onready var animation_state : AnimationNodeStateMachine = animation_state.get("parameters/playback")
onready var action_area : Area2D = $ActionArea


func _ready() -> void:
	# animation_tree.active = true
	pass


func get_input_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()


func _physics_process(delta: float) -> void:
	match current_state:
		IDLE:
			idle_state(delta)
		MOVE:
			move_state(delta)
	
	velocity = move_and_slide(velocity)


func idle_state(delta: float) -> void:
	var input_direction = get_input_direction()
	if input_direction != Vector2.ZERO:
		current_state = MOVE
		return
	
	# animation_state.travel("Idle")
	
	if velocity != Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)


func move_state(delta: float) -> void:
	var input_direction = get_input_direction()
	
	if input_direction != Vector2.ZERO:
		# animation_tree.set("parameters/Idle/blend_position", input_direction)
		# note: must to be done to all states on animation_tree
		
		# animation_tree.travel("Run")
		velocity = velocity.move_toward(
			input_direction * max_speed, 
			acceleration * delta)
	else:
		current_state = IDLE
