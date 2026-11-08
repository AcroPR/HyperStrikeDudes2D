class_name FighterPreview
extends TextureButton

@export var playerID: int = 0

@onready var background = $Background
@onready var label: Label = $Label
@onready var tagButton: PlayerButton = $TagButton

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
	tagButton.playerID = playerID
	texture_normal = null
	label.text = ""
