extends Spatial
class_name Interactable

onready var interactable_area : Area = $InteractableArea


func _ready() -> void:
	# interactable_area.connect("area_entered", self, "_on_area_entered")
	pass


func interact() -> void:
	print("INTERACT EXECUTED")
	pass
