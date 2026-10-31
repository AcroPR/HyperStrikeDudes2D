extends State

@export_category("States")
@export var airState: State
@export var blockState: State
@export var crouchState: State
@export var dashState: State
@export var emoteState: State
@export var grabState: State
@export var idleState: State
@export var jumpSquatState: State

var moveDir

func enter() -> void:
	super()
	moveDir = [inputComponent._pressed("move_left"),inputComponent._pressed("move_right")]
	parent._set_face_with_move_dir(moveDir)
	parent.animationPlayer.play("Walk")

func _input_dash() -> bool:
	if inputComponent._pressed("walk"):
		return false
		
	match parent.facingRight:
		true:
			return inputComponent._get_strength("move_right") >= parent.RUN_THRESHOLD
		false:
			return inputComponent._get_strength("move_left") >= parent.RUN_THRESHOLD
	return false

func process_physics(delta: float) -> State:
	if _input_dash():
		return dashState
	
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var walkSpeed = parent._get_velocity(parent.walkSpeed)
	
	match parent.facingRight:
		true:
			parent.velocity.x = walkSpeed
		false:
			parent.velocity.x = -walkSpeed
	
	if !parent._can_move():
		return idleState
	
	parent.move_and_slide()
	
	if inputComponent._just_pressed("attack"):
		return parent._return_attack_state()
	
	if inputComponent._just_pressed("heavy"):
		return parent._return_heavy_state()
	
	if inputComponent._just_pressed("special"):
		return parent._return_special_state()
	
	if inputComponent._just_pressed("jump"):
		return jumpSquatState
	
	if inputComponent._pressed("block"):
		return blockState
	
	#if inputComponent._just_pressed("emote"):
		#return emoteState
	
	if inputComponent._get_strength("move_down") >= parent.RUN_THRESHOLD:
		parent.set_collision_mask_value(3,false)
	
	if inputComponent._just_pressed("move_down"):
		return crouchState
	
	if !parent.is_on_floor():
		return airState
	
	return parent._return_attack_state_stick()
