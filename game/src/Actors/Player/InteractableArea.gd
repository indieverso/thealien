extends Area2D

var target


func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")


func _on_area_entered(area) -> void:
	print_debug("Area entered")
	target = area.get_parent()


func _on_area_exited(area) -> void:
	print_debug("Area exited")
	target = null


func can_interact() -> bool:
	return target != null


func handle_interact() -> void:
	if !can_interact():
		return
	target.interact()
