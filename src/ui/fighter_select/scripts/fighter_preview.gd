class_name FighterPreview
extends TextureButton

@export var playerID: int = 0

@onready var background = $Background
@onready var controlButton: PlayerButton = $Page0/ControlButton
@onready var labelPageZero: Label = $Page0/Label
@onready var pageZero: Control = $Page0
@onready var pageOne: Control = $Page1

func _set_player(_playerID: int):
	match _playerID:
		0:
			background.modulate = Color("45bce9")
		1:
			background.modulate = Color("579864ff")
		2:
			background.modulate = Color("af1a5dff")
		3:
			background.modulate = Color("593964ff")

func _ready() -> void:
	_set_player(playerID)
	controlButton.playerID = playerID
	texture_normal = null
	labelPageZero.text = ""
	pageZero.visible = true
	pageOne.visible = false

func _on_control_button_pressed() -> void:
	pageZero.visible = false
	pageOne.visible = true

func _on_exit_button_pressed() -> void:
	pageZero.visible = true
	pageOne.visible = false
