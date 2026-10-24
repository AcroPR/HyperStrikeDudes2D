extends State

@export_category("States")
@export var landing_state: State

func enter() -> void:
	super()

func _get_x_dir() -> int:
	var moveDir = [inputComponent._pressed("move_left"),inputComponent._pressed("move_right")]
	#parent._set_face(moveDir)
	match moveDir:
		[true,false]:
			return -1
		[false,true]:
			return 1
	return 0

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta

	# Move Direction (Horizontal)
	var xDir = _get_x_dir()
	
	parent.velocity.x = lerpf(parent.velocity.x, xDir * parent._get_velocity(parent.airSpeed), parent.airDrift*delta)
	
	parent.move_and_slide()
	
	if inputComponent._pressed("move_down"):
		parent.set_collision_mask_value(3,false)
	else:
		parent.set_collision_mask_value(3,true)
	
	#if inputComponent._just_pressed("shoot"):
		#parent._set_shoot_state()
	
	if parent.is_on_floor():
		parent.landingFrames = 4
		return landing_state
	
	return null
