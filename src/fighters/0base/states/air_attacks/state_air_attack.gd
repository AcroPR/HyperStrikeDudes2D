extends State

@export_category("States")
@export var airState: State
@export var landingState: State

@export_category("Attack Properties")
@export var animationName: String = "AttackN"
@export var landingLag: int = 4

func enter() -> void:
	super()
	parent.animationPlayer.play(animationName)

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
	if !parent.animationPlayer.is_playing():
		return airState
	return null

func process_physics(delta: float) -> State:
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
	
	if parent.is_on_floor():
		parent.landingFrames = landingLag
		#parent.landingFrames = 4
		return landingState
	
	return null
