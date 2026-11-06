extends State

@export_category("States")
@export var airState: State
@export var attackSideState: State
@export var blockState: State
@export var crouchState: State
@export var dashAttackState: State
@export var emoteState: State
@export var grabState: State
@export var jumpSquatState: State
@export var idleState: State

var moveDir

func enter() -> void:
	super()
	frames = 0

func process_frame(_delta: float) -> State:
	frames += 1
	
	if inputComponent._just_pressed("attack"):
		return dashAttackState
	
	if inputComponent._just_pressed("heavy"):
		return parent._return_heavy_state()
	
	if inputComponent._just_pressed("special"):
		return parent._return_special_state()
		
	if frames >= parent.dashFrames:
		return idleState
	return null

func process_physics(delta: float) -> State:
	
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var moonWalkSpeed = parent._get_velocity(parent.moonWalkSpeed)
	
	match parent.facingRight:
		true:
			parent.velocity.x = -moonWalkSpeed * 0.75
		false:
			parent.velocity.x = +moonWalkSpeed * 0.75
	
	parent.move_and_slide()
	
	if inputComponent._just_pressed("jump"):
		return jumpSquatState
	
	if inputComponent._pressed("block"):
		return blockState
	#
	#if inputComponent._just_pressed("emote"):
		#return emoteState
	
	if inputComponent._just_pressed("grab"):
		return grabState
	
	if inputComponent._get_strength("move_down") >= parent.RUN_THRESHOLD:
		parent.set_collision_mask_value(3,false)
	
	if !parent.is_on_floor():
		return airState
	
	if !parent._can_move() and !inputComponent._pressed("move_down"):
		return idleState
	
	return parent._return_attack_state_stick()
