extends State

@export_category("States")
@export var airState: State
@export var grabState: State
@export var idleState: State
@export var jumpSquatState: State
@export var rollState: State

func enter() -> void:
	super()
	parent.animationPlayer.play("Block")

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var groundFriction = parent._get_velocity(parent.groundFriction)
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, groundFriction)
	
	if inputComponent._just_pressed("move_left") or inputComponent._just_pressed("move_right"):
		return rollState
	
	parent.move_and_slide()
	
	if inputComponent._just_pressed("jump"):
		return jumpSquatState
	
	if !inputComponent._pressed("block"):
		return idleState
	
	if inputComponent._get_strength("move_down") >= parent.RUN_THRESHOLD:
		parent.set_collision_mask_value(3,false)
	
	if !parent.is_on_floor():
		return airState
	
	return null
