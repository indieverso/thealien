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


func authenticate(username: String, password: String) -> String:
	username = username.to_lower()
	if not players.has(username):
		return ""
	if players[username].password != password:
		return ""
	
	var at : = AuthToken.new()
	var token = at.generate_token({"username": username})
	
	return token
