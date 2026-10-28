extends VBoxContainer

@onready var angle: LineEdit = $Angle/LineEdit
@onready var baseKB: LineEdit = $BaseKB/LineEdit
@onready var hitstun: LineEdit = $Hitstun/LineEdit
@onready var kBScale: LineEdit = $KBScale/LineEdit

var hitboxNode: Hitbox

func _set_values(_hitboxNode: Hitbox):
	hitboxNode = _hitboxNode
	angle.text = str(hitboxNode.angle)
	baseKB.text = str(hitboxNode.baseKnockback)
	hitstun.text = str(hitboxNode.hitStun)
	kBScale.text = str(hitboxNode.knockbackScale)

func _angle_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.angle = int(new_text)
	else:
		angle.text = str(hitboxNode.angle)

func _base_kb_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.baseKnockback = int(new_text)
	else:
		baseKB.text = str(hitboxNode.baseKnockback)

func _hitstun_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.hitStun = int(new_text)
	else:
		hitstun.text = str(hitboxNode.hitStun)

func _kb_scale_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		hitboxNode.knockbackScale = float(new_text)
	else:
		kBScale.text = str(hitboxNode.knockbackScale)
