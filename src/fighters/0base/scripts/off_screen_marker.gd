class_name OffScreenMarker
extends Node2D

@export var parent: Fighter
@export var screenMargin: float = 45.0
@export var onScreenOffset: Vector2 = Vector2(0.5, -5)

@onready var sprite: Sprite2D = $SpriteBG/SpriteFighter
@onready var spriteBG: Sprite2D = $SpriteBG
@onready var locationIndicator: Sprite2D = $LocationIndicator

func _set_color(_playerID: int):
	match _playerID:
		1:
			locationIndicator.modulate = Color("45bce9")
		2:
			locationIndicator.modulate = Color("579864ff")
		3:
			locationIndicator.modulate = Color("af1a5dff")
		4:
			locationIndicator.modulate = Color("593964ff")

func _ready() -> void:
	spriteBG.visible = false
	locationIndicator.visible = false
	_set_color(parent.playerID+1)
	#sprite.texture = parent.get_node("SubViewportContainer/SubViewport").get_texture()

func _process(_delta: float) -> void:
	var viewport = get_viewport()
	var viewportRect = viewport.get_visible_rect()
	var canvasTransform = viewport.get_canvas_transform()

	# Convert player's world position into screen coordinates.
	var screenPosition: Vector2 = canvasTransform * parent.global_position

	# Check whether the player is inside the screen margins.
	var screenBounds = viewportRect.grow(-screenMargin)

	if screenBounds.has_point(screenPosition):
		sprite.visible = false
		spriteBG.visible = false
		locationIndicator.visible = false
		return

	sprite.visible = true
	spriteBG.visible = true
	locationIndicator.visible = true

	# Clamp the player's screen position to the screen boundaries.
	var clampedScreenPosition = Vector2(
		clamp(screenPosition.x, screenBounds.position.x, screenBounds.end.x),
		clamp(screenPosition.y, screenBounds.position.y, screenBounds.end.y)
	)

	# Convert the clamped screen position back into world coordinates.
	var inverseCanvasTransform = canvasTransform.affine_inverse()
	var targetDisplayPosition = inverseCanvasTransform * clampedScreenPosition

	global_position = targetDisplayPosition

	# Rotate marker toward the player.
	locationIndicator.global_rotation = (parent.global_position - global_position).angle() - PI * 0.5
