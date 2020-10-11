extends Node
class_name PlayerStore

var players = {
	"test": {
		"password": "test"
	},
	"user": {
		"password": "123"
	}
}


func _init():
	pass


func authenticate(username: String, password: String) -> bool:
	username = username.to_lower()
	if not players.has(username):
		return false
	if players[username].password != password:
		return false
	return true
