extends State

const AIR_DODGE_FRAMES = 40

@export_category("States")
@export var airState: State
@export var landingState: State

func enter() -> void:
	super()
	frames = 0

func _get_x_dir() -> int:
	var moveDir = [inputComponent._pressed("move_left"),inputComponent._pressed("move_right")]
	#parent._set_face(moveDir)
	match moveDir:
		[true,false]:
			return -1
		[false,true]:
			return 1
	return 0

func process_frame(_delta: float) -> State:
	frames += 1
	if frames >= AIR_DODGE_FRAMES:
		return airState
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta

	# Move Direction (Horizontal)
	var xDir = _get_x_dir()
	
	parent.velocity.x = lerpf(parent.velocity.x, xDir * parent._get_velocity(parent.airSpeed), parent.airDrift*delta)
	
	parent.move_and_slide()
	
	#if inputComponent._just_pressed("shoot"):
		#parent._set_shoot_state()
	
	if parent.is_on_floor():
		parent.landingFrames = 30
		return landingState
	
	return null
