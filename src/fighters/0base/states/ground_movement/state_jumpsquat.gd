extends State

@export_category("States")
@export var airState: State

func enter() -> void:
	super()
	frames = 0
	parent.animationPlayer.play("JumpSquat")

func process_frame(_delta: float) -> State:
	frames+=1
	if frames >= parent.jumpSquatFrames:
		if inputComponent._pressed("jump"):
			parent.velocity.y = -parent._get_velocity(parent.jumpHeight)
		else:
			parent.velocity.y = -parent._get_velocity(parent.hopHeight)
		return airState
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var groundFriction = parent._get_velocity(parent.groundFriction)
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, groundFriction)
	
	parent.move_and_slide()
	
	return null
