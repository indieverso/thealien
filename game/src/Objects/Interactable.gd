extends Node2D
class_name Interactable

onready var interactable_area : Area2D = $InteractableArea


func _ready() -> void:
	# interactable_area.connect("area_entered", self, "_on_area_entered")
	pass


func interact() -> void:
	print("INTERACT EXECUTED")
	pass
