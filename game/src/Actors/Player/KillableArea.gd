extends Area

var target


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body) -> void:
	if _is_current_player(body.player_info.id):
		return
	print_debug("Player entered")
	target = body


func _on_body_exited(body) -> void:
	if _is_current_player(body.player_info.id):
		return
	print_debug("Player exited")
	target = null


func _is_current_player(id: int) -> bool:
	return id == get_tree().get_network_unique_id()


func can_kill() -> bool:
	return target != null and target.is_alive


func handle_kill() -> void:
	print("YOU JUST KILLED: " + str(target.player_info.id))
