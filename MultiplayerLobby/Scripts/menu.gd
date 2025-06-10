extends Control

@onready var network: NetworkManager = get_node("/root/Main/NetworkManager")
@onready var main_screen = $CanvasLayer/BG/MainMenu
@onready var lobby_screen = $CanvasLayer/BG/lobby

func _ready():
	network.OnConnecteToServer.connect(open_lobby_menu)
	network.OnServerDisconnected.connect(open_lobby_menu)
func open_main_menu():
	main_screen.visible = true
	lobby_screen.visible = false
func open_lobby_menu():
	main_screen.visible = false
	lobby_screen.visible = true
