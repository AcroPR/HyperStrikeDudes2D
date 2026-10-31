extends State

@export_category("States")
@export var airDodgeState: State
@export var landingState: State

var check_jump: bool

func enter() -> void:
	super()
	frames = 0
	check_jump = false

func _get_animation():
	if parent.velocity.y > 0: parent.animationPlayer.play("AirDown")
	else: parent.animationPlayer.play("AirUp")

func _get_x_dir() -> int:
	var moveDir = [inputComponent._pressed("move_left"),inputComponent._pressed("move_right")]
	#parent._set_face_with_move_dir(moveDir)
	match moveDir:
		[true,false]:
			return -1
		[false,true]:
			return 1
	return 0

func process_frame(_delta: float) -> State:
	if !inputComponent._pressed("jump"):
		inputComponent._hard_release("jump")
		check_jump = true
	return null

func process_physics(delta: float) -> State:
	if inputComponent._just_pressed("jump") and parent.airJumpCount < parent.maxAirJumps and check_jump:
		parent.isFastFalling = false
		check_jump = false
		var midAirMultiplier = 1.15 - (float(parent.airJumpCount) / float(parent.maxAirJumps))
		if midAirMultiplier > 1.0: midAirMultiplier = 1.0
		var midAirJumpHeight = parent.airJumpHeight * midAirMultiplier
		parent.airJumpCount += 1
		parent.velocity.y = -parent._get_velocity(midAirJumpHeight)
	
	if inputComponent._just_pressed("move_down"):
		parent.isFastFalling = true
	
	match parent.isFastFalling:
		true:
			parent.velocity.y += parent._get_velocity(parent.weight) * parent.fastFallMultiplier * delta
		false:
			parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	parent.ledgeGrabBox.monitoring = parent.velocity.y > 0

	# Move Direction (Horizontal)
	var xDir = _get_x_dir()
	
	parent.velocity.x = lerpf(parent.velocity.x, xDir * parent._get_velocity(parent.airSpeed), parent.airDrift*delta)
	
	parent.move_and_slide()
	
	_get_animation()
	
	if inputComponent._just_pressed("attack"):
		return parent._return_air_attack_state()
	
	if inputComponent._just_pressed("special"):
		return parent._return_special_state()
	
	if inputComponent._pressed("move_down"):
		parent.set_collision_mask_value(3,false)
	else:
		parent.set_collision_mask_value(3,true)
	
	if inputComponent._just_pressed("block"):
		return airDodgeState
	
	if parent.is_on_floor():
		parent.landingFrames = 4
		return landingState
	
	return parent._return_air_state_stick()
