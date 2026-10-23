extends State

@export_category("States")
@export var airState: State
@export var blockState: State
@export var dashState: State
@export var emoteState: State
@export var grabState: State
@export var jumpSquatState: State
@export var walkState: State

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var groundFriction = parent._get_velocity(parent.groundFriction)
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, groundFriction)
	
	if parent._can_move():
		return walkState
	
	parent.move_and_slide()
	
	if inputComponent._just_pressed("jump"):
		return jumpSquatState
	
	if inputComponent._just_pressed("block"):
		return blockState
	
	if inputComponent._just_pressed("emote"):
		return emoteState
	
	if inputComponent._get_strength("move_down") >= parent.RUN_THRESHOLD:
		parent.set_collision_mask_value(3,false)
	
	if !parent.is_on_floor():
		return airState
	
	return null
