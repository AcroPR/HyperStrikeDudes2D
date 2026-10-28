extends VBoxContainer

@onready var hitLag: LineEdit = $Hitlag/LineEdit

var hitboxNode: Hitbox

func _set_values(_hitboxNode: Hitbox):
	hitboxNode = _hitboxNode
	hitLag.text = str(hitboxNode.hitLag)

func _hit_lag_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.hitLag = int(new_text)
	else:
		hitLag.text = str(hitboxNode.hitLag)
