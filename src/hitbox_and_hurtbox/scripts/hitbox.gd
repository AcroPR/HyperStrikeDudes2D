@tool
class_name Hitbox
extends Area2D

@export_category("CollisionShape2D")
@export var disabled: bool = false : set = _update_disabled
@export var hitbox_color = Color(1.0, 0.0, 0.0, 0.42) : set = _update_color
@export var shape : Shape2D = null : set = _update_shape

#@export_category("Hitbox Data")
#@export var hitbox_id: int = 0 : set = update_id
#@export var hitbox_priority: int = 0 : set = update_priority
#@export var frames_active: int = 1 : set = update_frames
#@export var damage: int = 0 : set = update_damage
#@export var hit_stun: int = 0 : set = update_hs
#@export var angle: int = 0 : set = update_angle
#@export var base_knockback: int = 0 : set = update_bkb
#@export_range(0,1) var knockback_scale: float = 0.0 : set = update_kbs
#@export var hit_lag: int = 0 : set = update_hl
#@export var group: int = 0 : set = update_group

# Enables and disables the hitbox
func _update_disabled(newVal):
	for obj in get_children():
		obj.disabled = newVal
	disabled = newVal
	queue_redraw()
	
# Updates the hitbox color
func _update_color(new_val: Color) -> void:
	hitbox_color = new_val
	for obj in get_children():
		if obj is CollisionShape2D:
			obj.debug_color = hitbox_color
	queue_redraw()

# Updates the hitbox's collision shape
func _update_shape(newVal):
	shape = newVal
	for collision in get_children():
		if collision is CollisionShape2D:
			collision.set_shape(newVal)
	queue_redraw()
