extends State

@export_category("States")
@export var airState: State
@export var blockState: State
@export var emoteState: State
@export var grabState: State
@export var skidState: State
@export var jumpSquatState: State

var moveDir

func enter() -> void:
	super()
	moveDir = [inputComponent._pressed("move_left"),inputComponent._pressed("move_right")]
	parent._set_face(moveDir)

func process_physics(delta: float) -> State:
	
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var walkSpeed = parent._get_velocity(parent.runSpeed)
	
	match parent.facingRight:
		true:
			parent.velocity.x = walkSpeed
		false:
			parent.velocity.x = -walkSpeed
	
	if !parent._can_move() or !parent._is_dashing_correctly():
		return skidState
	
	parent.move_and_slide()
	
	if inputComponent._just_pressed("jump"):
		return jumpSquatState
	
	#if inputComponent._just_pressed("guard"):
		#return guardState
	#
	#if inputComponent._just_pressed("emote"):
		#return emoteState
	#
	#if inputComponent._just_pressed("shoot"):
		#parent._set_shoot_state()
	
	if inputComponent._get_strength("move_down") >= parent.RUN_THRESHOLD:
		parent.set_collision_mask_value(3,false)
	
	if !parent.is_on_floor():
		return airState
	
	return null
