@tool
class_name Hitbox
extends Area2D

@export_category("CollisionShape2D")
@export var hitbox_color = Color(1.0, 0.0, 0.0, 0.42) : set = _update_color
@export var shape : Shape2D = null : set = _update_shape

@export_category("Hitbox Data")
@export_range(0,365) var angle: int = 0 : set = _update_angle
@export_range(0,999) var baseKnockback: int = 0 : set = _update_bkb
@export_range(0,999) var damage: int = 0 : set = _update_damage
@export_range(1,99) var framesActive: int = 1 : set = _update_frames
@export_range(0,4) var hitboxId: int = 0 : set = _update_id
@export_range(0,999) var hitLag: int = 0 : set = _update_hl
@export_range(0,5) var hitboxPriority: int = 0 : set = _update_priority
@export_range(0,999) var hitStun: int = 0 : set = _update_hs
@export_range(0,1) var knockbackScale: float = 0.0 : set = _update_kbs

@export_category("Extras")
@export var paused: bool = false : set = _update_paused

var frame: int

# Updates knockback angle
func _update_angle(newVal):
	angle = newVal
	queue_redraw()

# Updates the base knockback
func _update_bkb(newVal):
	baseKnockback = newVal
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
	framesActive = newVal
	queue_redraw()

# Updates hit stun value
func _update_hs(newVal):
	hitStun = newVal
	queue_redraw()

# Updates the hitbox id
func _update_id(newVal):
	hitboxId = newVal
	queue_redraw()

# Updates hit lag value
func _update_hl(newVal):
	hitLag = newVal
	queue_redraw()

# Updates the knockback scale
func _update_kbs(newVal):
	knockbackScale = newVal
	queue_redraw()

# Updates the knockback scale
func _update_paused(newVal):
	paused = newVal
	queue_redraw()

# Updates the hitbox priority
func _update_priority(newVal):
	hitboxPriority = newVal
	queue_redraw()

# Updates the hitbox's collision shape
func _update_shape(newVal):
	shape = newVal
	for collision in get_children():
		if collision is CollisionShape2D:
			collision.set_shape(newVal)
	queue_redraw()

# Custom constructor
func _init(width: int = 0, height: int = 0, initX: int = 0, initY: int = 0, initPaused: bool = false, initId = 0, initPriority: int = 0, initFrames: int = 1, initDamage: int = 0, initHitStun: int = 0, initAngle: int = 0, initBkb: int = 0, initKbs: float = 0.0, initHitLag: int = 0):
	var rectangleShape = RectangleShape2D.new()
	rectangleShape.extents.x = width
	rectangleShape.extents.y = height
	
	shape = rectangleShape
	position.x = initX
	position.y = initY
	paused = initPaused
	hitboxId = initId
	hitboxPriority = initPriority
	framesActive = initFrames
	damage = initDamage
	hitStun = initHitStun
	angle = initAngle
	baseKnockback = initBkb
	knockbackScale = initKbs
	hitLag = initHitLag

func _ready() -> void:
	frame = 0
	var collision = CollisionShape2D.new()
	collision.debug_color = hitbox_color
	collision.set_shape(shape)
	add_child(collision)

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint() and !paused:
		if frame < framesActive:
			frame += 1
		else:
			queue_free()

# Calculates the launch vector to apply knockback
# @param launch_angle - angle (int)
# @param force - base_knockback (int)
# @returns Vector to apply knockback
func _get_launch_vector(launch_angle,force):
	#Converts angle to radians
	launch_angle = launch_angle * PI / 180
	
	#Get X and Y components of vector
	var fx = force * cos(launch_angle)
	var fy = -force * sin(launch_angle)
	
	#Returns the vector of fx and fy
	#match reverse:
		#true:
			#return Vector2(fx*-1,fy)
		#false:
			#return Vector2(fx,fy)
	return Vector2(fx,fy)

# Draws a line to show the knockback angle IN THE EDITOR
func _draw():
	if not Engine.is_editor_hint() and !paused:# and !draw_line_in_game:
		return
	draw_rect(Rect2(0 - shape.extents.x, 0 - shape.extents.y, shape.extents.x * 2, shape.extents.y * 2), Color(1, 0, 0, 0.5))
	draw_line(Vector2(),_get_launch_vector(angle,baseKnockback), Color('#ffffff'),5)
