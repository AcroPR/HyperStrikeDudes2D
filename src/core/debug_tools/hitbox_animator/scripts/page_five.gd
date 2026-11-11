@tool
extends VBoxContainer

@onready var group: LineEdit = $Group/LineEdit
@onready var diMultiplier: LineEdit = $DIMultiplier/LineEdit

var hitboxNode: Hitbox

func _set_values(_hitboxNode: Hitbox):
	hitboxNode = _hitboxNode
	group.text = str(hitboxNode.group)
	diMultiplier.text = str(hitboxNode.diMultiplier)

func _on_di_multiplier_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		hitboxNode.diMultiplier = float(new_text)
	else:
		diMultiplier.text = str(hitboxNode.diMultiplier)
	
func _group_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.hitStop = int(new_text)
	else:
		group.text = str(hitboxNode.group)
