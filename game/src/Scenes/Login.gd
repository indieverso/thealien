extends Control


onready var username_input: LineEdit = $MarginContainer/VBoxContainer/LoginScreen/UsernameInput
onready var password_input: LineEdit = $MarginContainer/VBoxContainer/LoginScreen/PasswordInput
onready var login_button: Button = $MarginContainer/VBoxContainer/LoginScreen/LoginButton


func _ready() -> void:
	GatewayServer.connect("login_succeeded", self, "_on_login_succeeded")
	GatewayServer.connect("login_failed", self, "_on_login_failed")
	GatewayServer.connect("authenticating", self, "_on_authenticating")


# Controls login button state based on username and password content
func _on_input_text_changed(new_text: String) -> void:
	if username_input.text != "" and password_input.text != "":
		login_button.disabled = false
		return
	login_button.disabled = true


func _on_LoginButton_pressed() -> void:
	var username = username_input.text
	var password = password_input.text
	
	if username == "" or password == "":
		print_debug("Please provide valid username and password")
		return
	
	login_button.disabled = true
	print_debug("Attempt to login.")
	GatewayServer.login(username, password)


func _on_login_failed() -> void:
	print_debug("Failed to login.")
	login_button.disabled = false


func _on_login_succeeded() -> void:
	print_debug("Succesfully logged.")
	login_button.disabled = false
	
	GameServer.connect_to_server()


func _on_authenticating() -> void:
	print_debug("Authenticating")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
