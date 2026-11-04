@tool
extends VBoxContainer

@onready var hitStop: LineEdit = $Hitstop/LineEdit
@onready var blockDamage: LineEdit = $BlockDamage/LineEdit
@onready var type: OptionButton = $Type/OptionButton
@onready var reversable: CheckBox = $Reversable/CheckButton

var hitboxNode: Hitbox

func _set_values(_hitboxNode: Hitbox):
	hitboxNode = _hitboxNode
	hitStop.text = str(hitboxNode.hitStop)
	blockDamage.text = str(hitboxNode.blockDamage)
	type.select(hitboxNode.type)
	reversable.button_pressed = hitboxNode.reversable

func _block_damage_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.blockDamage = int(new_text)
	else:
		hitStop.text = str(hitboxNode.hitStop)

func _hit_stop_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.hitStop = int(new_text)
	else:
		hitStop.text = str(hitboxNode.hitStop)

func _on_type_selected(index: int) -> void:
	hitboxNode.type = index

func _on_reversable_toggled(toggled_on: bool) -> void:
	hitboxNode.reversable = toggled_on
