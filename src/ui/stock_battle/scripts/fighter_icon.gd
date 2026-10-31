class_name FighterIcon
extends TextureRect

@onready var bgColor: TextureRect = $BGColor
@onready var player: Label = $Player
@onready var percent: Label = $Percent
@onready var lives: Label = $Lives

func _set_player(_playerID: int):
	player.text = "P" + str(_playerID)
	match _playerID:
		1:
			bgColor.modulate = Color("45bce9")
		2:
			bgColor.modulate = Color("579864ff")
		3:
			bgColor.modulate = Color("af1a5dff")
		4:
			bgColor.modulate = Color("593964ff")

func _set_percent(_percent: int):
	percent.text = str(_percent) + "%"

func _set_lives(_playerID: int):
	lives.text = str(MatchGlobal.playerLives[_playerID])
