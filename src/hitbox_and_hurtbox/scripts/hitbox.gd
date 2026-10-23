@tool
class_name Hitbox
extends Area2D

@export_category("CollisionShape2D")
@export var hitbox_color = Color(1.0, 0.0, 0.0, 0.42) : set = _update_color
@export var shape : Shape2D = null : set = _update_shape

@export_category("Hitbox Data")
@export_range(0,365) var angle: int = 0 : set = _update_angle
@export_range(0,999) var base_knockback: int = 0 : set = _update_bkb
@export_range(0,999) var damage: int = 0 : set = _update_damage
@export_range(1,99) var frames_active: int = 1 : set = _update_frames
@export_range(0,4) var hitbox_id: int = 0 : set = _update_id
@export_range(0,999) var hit_lag: int = 0 : set = _update_hl
@export_range(0,5) var hitbox_priority: int = 0 : set = _update_priority
@export_range(0,999) var hit_stun: int = 0 : set = _update_hs
@export_range(0,1) var knockback_scale: float = 0.0 : set = _update_kbs

# Updates knockback angle
func _update_angle(newVal):
	angle = newVal
	queue_redraw()

# Updates the base knockback
func _update_bkb(newVal):
	base_knockback = newVal
	queue_redraw()

# Updates the hitbox color
func _update_color(new_val: Color) -> void:
	hitbox_color = new_val
	for obj in get_children():
		if obj is CollisionShape2D:
			obj.debug_color = hitbox_color
	queue_redraw()

# Updates the hitbox damage
func _update_damage(newVal):
	damage = newVal
	queue_redraw()

# Updates the hitbox frame data
func _update_frames(newVal):
	frames_active = newVal
	queue_redraw()

# Updates hit stun value
func _update_hs(newVal):
	hit_stun = newVal
	queue_redraw()

# Updates the hitbox id
func _update_id(newVal):
	hitbox_id = newVal
	queue_redraw()

# Updates the knockback scale
func _update_kbs(newVal):
	knockback_scale = newVal
	queue_redraw()

# Updates hit lag value
func _update_hl(newVal):
	hit_lag = newVal
	queue_redraw()

# Updates the hitbox priority
func _update_priority(newVal):
	hitbox_priority = newVal
	queue_redraw()

# Updates the hitbox's collision shape
func _update_shape(newVal):
	shape = newVal
	for collision in get_children():
		if collision is CollisionShape2D:
			collision.set_shape(newVal)
	queue_redraw()
