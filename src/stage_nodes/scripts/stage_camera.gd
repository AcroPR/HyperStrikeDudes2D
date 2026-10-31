@tool
class_name StageCamera
extends Camera2D

@export var moveSpeed: float = 0.5
@export var zoomSpeed: float = 0.05
@export var minZoom: float = 1.0
@export var maxZoom: float = 1.25

var targets = []

@onready var screenSize = get_viewport_rect().size

func _add_target(target):
	if !(target in targets):
		targets.append(target)

func _remove_target(target):
	if target in targets:
		targets.erase(target)

func _set_camera_position() -> void:
	var newPos = Vector2.ZERO
	for target in targets:
		newPos += target.position
	newPos /= targets.size()
	position = lerp(position, newPos, moveSpeed)

func _set_camera_zoom():
	var maxDistance = _get_max_target_distance()
	#print(maxDistance)
	var zoomLevel = clamp(maxZoom - (maxDistance / 1920), minZoom, maxZoom)
	zoom = Vector2(zoomLevel, zoomLevel)

func _get_max_target_distance():
	var maxDistance = 0.0
	var lastTarget = null
	for target in targets:
		if lastTarget != null:
			var distance = lastTarget.global_position.distance_to(target.global_position)
			if distance > maxDistance:
				maxDistance = distance
			
		lastTarget = target
		
	return maxDistance

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if !targets:
		return
	_set_camera_position()
	_set_camera_zoom()
