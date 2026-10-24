class_name OffScreenMarker
extends Node2D

@export var onScreenOffset: Vector2 = Vector2(0.5, -5)
@export var parent: Node2D
@export var screenMargin: float = 45.0

@onready var sprite: Sprite2D = $Sprite2D

var camera: Camera2D

func _ready() -> void:
	camera = get_viewport().get_camera_2d()
	sprite.texture = parent.get_node("SubViewportContainer/SubViewport").get_texture()

func _process(_delta: float) -> void:
	var targetGlobalPosition: Vector2 = parent.global_position
	var viewportDimensions: Vector2 = get_viewport().get_visible_rect().size
	var screenCoordinates: Vector2 = (targetGlobalPosition - camera.global_position) * camera.zoom + viewportDimensions * 0.5
	var screenInsetRectangle: Rect2 = Rect2(Vector2.ZERO, viewportDimensions).grow(-screenMargin)
	
	var targetDisplayPosition: Vector2
	var targetDisplayRotation: float
	
	if screenInsetRectangle.has_point(screenCoordinates):
		visible = false
		#targetDisplayPosition = targetGlobalPosition + onScreenOffset
		#targetDisplayRotation = 0.0
	else:
		visible = true
		var clampedX = clamp(screenCoordinates.x, screenMargin, viewportDimensions.x - screenMargin)
		var clampedY = clamp(screenCoordinates.y, screenMargin, viewportDimensions.y - screenMargin)
		var clampedScreenCoords: Vector2 = Vector2 (clampedX, clampedY)
		targetDisplayPosition = camera.global_position + (clampedScreenCoords - viewportDimensions * 0.5) / camera.zoom
		var vectorToTarget: Vector2 = targetGlobalPosition - targetDisplayPosition
		targetDisplayRotation = vectorToTarget.angle() - PI * 0.5
	
	global_position = targetDisplayPosition
	rotation = targetDisplayRotation
