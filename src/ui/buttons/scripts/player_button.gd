class_name PlayerButton
extends ButtonUniversal

var playerID: int = 0
var playerMouse: MouseCustom = null

func _on_area_2d_area_entered(_area: Area2D) -> void:
	var mouse: MouseCustom = _area.get_parent()
	if playerID == mouse.playerID:
		mouse.buttonHovered = self
		playerMouse = mouse

func _on_area_2d_area_exited(_area: Area2D) -> void:
	var mouse: MouseCustom = _area.get_parent()
	if playerID == mouse.playerID:
		mouse.buttonHovered = null
		playerMouse = null

func _press_button() -> void:
	_pressed.emit()

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	_on_visibility_changed()

func _process(_delta: float) -> void:
	if playerMouse != null:
		add_theme_stylebox_override("normal", get_theme_stylebox("hover"))
	else:
		remove_theme_stylebox_override("normal")

func _on_visibility_changed() -> void:
	area.monitorable = is_visible_in_tree()
	area.monitoring = is_visible_in_tree()
