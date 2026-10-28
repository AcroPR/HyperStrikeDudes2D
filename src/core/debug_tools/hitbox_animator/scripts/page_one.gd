extends VBoxContainer

@onready var hitboxWidth: LineEdit = $HitboxWidth/LineEdit
@onready var hitboxHeight: LineEdit = $HitboxHeight/LineEdit
@onready var positionX: LineEdit = $PositionX/LineEdit
@onready var positionY: LineEdit = $PositionY/LineEdit

var hitboxNode: Hitbox

func _set_values(_hitboxNode: Hitbox):
	hitboxNode = _hitboxNode
	hitboxWidth.text = str(int(hitboxNode.shape.extents.x))
	hitboxHeight.text = str(int(hitboxNode.shape.extents.y))
	positionX.text = str(int(hitboxNode.position.x))
	positionY.text = str(int(hitboxNode.position.y))

func _hitbox_width_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.shape.extents.x = int(new_text)
	else:
		hitboxWidth.text = str(int(hitboxNode.shape.extents.x))

func _hitbox_height_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.shape.extents.y = int(new_text)
	else:
		hitboxWidth.text = str(int(hitboxNode.shape.extents.y))

func _position_x_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.position.x = int(new_text)
	else:
		hitboxWidth.text = str(int(hitboxNode.position.x))

func _position_y_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.position.y = int(new_text)
	else:
		hitboxWidth.text = str(int(hitboxNode.position.y))
