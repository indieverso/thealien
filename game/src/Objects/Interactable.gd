extends StaticBody
class_name Interactable

onready var interactable_area: Area = $InteractableArea
onready var skin : MeshInstance = $MeshInstance

export var hover_material : SpatialMaterial

var in_range := false


func _ready() -> void:
	interactable_area.connect("area_entered", self, "_on_area_entered")
	interactable_area.connect("area_exited", self, "_on_area_exited")


func interact() -> void:
	if not in_range:
		return
	print("INTERACT EXECUTED")


func _on_area_entered(_area: Area) -> void:
	skin.get_surface_material(0).next_pass = hover_material
	in_range = true


func _on_area_exited(_area: Area) -> void:
	skin.get_surface_material(0).next_pass = null
	in_range = false
