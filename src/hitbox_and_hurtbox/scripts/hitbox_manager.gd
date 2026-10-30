@tool
class_name HitboxManager
extends Node2D

@export var fighter: Fighter

func _create_hitbox():
	pass

func _delete_hitboxes():
	for hitbox in get_children():
		hitbox.queue_free()

func _set_paused(_bool: bool):
	for child: Hitbox in get_children():
		child.paused = _bool
