class_name FighterIcon
extends TextureRect

@onready var bgColor: TextureRect = $BGColor
@onready var player: Label = $Player
@onready var percent: Label = $Percent
@onready var lives: Label = $Lives

var enableShake: bool = false

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
	if enableShake: _shake_text(percent, 251.0)

func _set_lives(_playerID: int):
	lives.text = str(MatchGlobal.playerLives[_playerID])
	if enableShake: _shake_text(lives, 178.0)

func _shake_text(_label: Label, defaultPostion: float):
	var tweenValues = [defaultPostion,defaultPostion+5,defaultPostion-5,defaultPostion]
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	for tweenValue in tweenValues:
		tween.tween_property(_label, "position:y", tweenValue, 0.1)
