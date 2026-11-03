class_name BlockBubble
extends Node2D

@export var parent: Fighter

@onready var hitBubble: Sprite2D = $HitBubble
@onready var mainBubble: Sprite2D = $MainBubble
@onready var subBubble: Sprite2D = $SubBubble

func _set_color(_playerID: int):
	match _playerID:
		1:
			mainBubble.modulate = Color("45bce9")
		2:
			mainBubble.modulate = Color("579864ff")
		3:
			mainBubble.modulate = Color("af1a5dff")
		4:
			mainBubble.modulate = Color("593964ff")

func _ready() -> void:
	hitBubble.visible = false
	visible = false
	_set_color(parent.playerID+1)

func _process(_delta: float) -> void:
	if visible:
		var _scale = (parent.MAX_BLOCK_HEALTH - parent.blockHealth) / parent.MAX_BLOCK_HEALTH
		subBubble.scale = Vector2(_scale,_scale)
