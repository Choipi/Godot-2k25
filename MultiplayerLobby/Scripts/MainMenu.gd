extends Control


@onready var network: NetworkManager = get_node("/root/Main/NetworkManager")

@onready var username_input = $UsernameInput
@onready var ip_input = $"IP input"
@onready var port_input = $"Port Input"

func _on_button_pressed():
	network.local_username = username_input.text
	network.start_host(int(port_input.text))


func _on_button_2_pressed():
	network.local_username = username_input.text
	network.start_client(ip_input.text, int(port_input.text))
