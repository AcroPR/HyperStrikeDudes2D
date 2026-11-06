@tool
class_name FighterButton
extends TextureButton

@onready var label: Label = $Label

@export var fighterIcon: Texture2D = null : set = _update_fighter_icon
@export var fighterName: String = "" : set = _update_fighter_name
@export var fighterID: String = "0base"

func _update_fighter_name(newValue: String):
	fighterName = newValue
	var labelNode = get_node_or_null("Label")
	if labelNode:
		labelNode.text = fighterName

func _update_fighter_icon(newValue: Texture2D):
	fighterIcon = newValue
	texture_normal = fighterIcon

func _ready() -> void:
	_update_fighter_name(fighterName)


func _on_area_2d_area_entered(area: Area2D) -> void:
	var mouse: MouseCustom = area.get_parent()
	mouse._update_fighter_id_and_name(fighterID,fighterName)

func _on_area_2d_area_exited(area: Area2D) -> void:
	var mouse: MouseCustom = area.get_parent()
	mouse._update_fighter_id_and_name("","")
