tool
class_name Player
extends KinematicBody
# Helper class for the Player scene's scripts to be able to have access to the
# camera and its orientation.

var player_info : = {}

export var is_alive : bool = true
export var is_alien : bool = false

puppet var puppet_transform : Transform
puppet var puppet_velocity : Vector3 = Vector3.ZERO

onready var camera := $CameraGimbal
onready var skin : Mannequiny = $Mannequiny
onready var state_machine: StateMachine = $StateMachine

var velocity : Vector3


func _get_configuration_warning() -> String:
	return "Missing camera node" if not camera else ""


func init(info) -> void:
	player_info = info
	name = str(player_info.id)
	global_transform = player_info.position
	set_network_master(player_info.id)
	$Viewport/PlayerLabel/Label.text = name


func _ready() -> void:
	_set_player_color()
	if player_info.id == get_tree().get_network_unique_id():
		camera.get_node("InnerGimbal/Camera").current = true


func _set_player_color() -> void:
	var material := SpatialMaterial.new()
	material.albedo_color = (player_info.color as Color)
	skin.get_node("MeshInstance").material_override = material


func _physics_process(delta: float) -> void:
	if get_tree().network_peer && is_network_master():
		rset_unreliable("puppet_transform", transform)
		rset_unreliable("puppet_velocity", velocity)
	else:
		global_transform = puppet_transform
		velocity = puppet_velocity
