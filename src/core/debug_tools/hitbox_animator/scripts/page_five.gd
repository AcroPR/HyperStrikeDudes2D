@tool
extends VBoxContainer

@onready var group: LineEdit = $Group/LineEdit

var hitboxNode: Hitbox

func _set_values(_hitboxNode: Hitbox):
	hitboxNode = _hitboxNode
	group.text = str(hitboxNode.group)

func _group_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.group = int(new_text)
	else:
		group.text = str(hitboxNode.hitStop)

func _hit_lag_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.hitStop = int(new_text)
	else:
		group.text = str(hitboxNode.group)

func _on_type_selected(index: int) -> void:
	hitboxNode.type = index

func _on_reversable_toggled(toggled_on: bool) -> void:
	hitboxNode.reversable = toggled_on
