@tool
extends VBoxContainer

@onready var hitLag: LineEdit = $Hitlag/LineEdit
@onready var blockDamage: LineEdit = $BlockDamage/LineEdit
@onready var type: OptionButton = $Type/OptionButton
@onready var reversable: CheckBox = $Reversable/CheckButton

var hitboxNode: Hitbox

func _set_values(_hitboxNode: Hitbox):
	hitboxNode = _hitboxNode
	hitLag.text = str(hitboxNode.hitLag)
	blockDamage.text = str(hitboxNode.blockDamage)
	type.select(hitboxNode.type)
	reversable.button_pressed = hitboxNode.reversable

func _block_damage_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.hitLag = int(new_text)
	else:
		hitLag.text = str(hitboxNode.hitLag)

func _hit_lag_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.hitLag = int(new_text)
	else:
		hitLag.text = str(hitboxNode.hitLag)

func _on_type_selected(index: int) -> void:
	hitboxNode.type = index

func _on_reversable_toggled(toggled_on: bool) -> void:
	hitboxNode.reversable = toggled_on
