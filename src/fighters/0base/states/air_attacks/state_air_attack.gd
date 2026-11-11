extends State

@export_category("States")
@export var airState: State
@export var landingState: State

@export_category("Attack Properties")
@export var animationName: String = "AttackN"
@export var landingLag: int = 4

# Array of attack hitboxes
var attackHitboxes

var previousFrame: int

func enter() -> void:
	super()
	previousFrame = -1
	parent.animationPlayer.play(animationName)
	attackHitboxes = HitboxImporter._load_csv(parent.fighterFolderName, animationName)
	parent._add_stale_move(animationName)

func _get_x_dir() -> int:
	var moveDir = [inputComponent._pressed("move_left"),inputComponent._pressed("move_right")]
	#parent._set_face_with_move_dir(moveDir)
	match moveDir:
		[true,false]:
			return -1
		[false,true]:
			return 1
	return 0

func _create_hitbox(current_hitbox):
	var new_hitbox = Hitbox.new()._build_from_array(current_hitbox,false,0)
	new_hitbox.reversed = parent.model.scale.x < 0
	new_hitbox.parent = parent
	new_hitbox.attackName = animationName
	#if parent.hitbox_group == new_hitbox.group:
		#new_hitbox.objects_hit[0] = true
	parent.hitboxManager.add_child(new_hitbox)

func _check_for_hitboxes():
	var currentFrame = int(parent.animationPlayer.current_animation_position * 60)
	for currentHitbox in attackHitboxes:
		if currentFrame == currentHitbox[0] and previousFrame < currentFrame:
			_create_hitbox(currentHitbox)
			previousFrame = currentFrame

func process_frame(_delta: float) -> State:
	_check_for_hitboxes()
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
		if parent.smoothLanding:
			parent.landingFrames = 4
			parent.smoothLanding = false
		else:
			parent.landingFrames = landingLag
		return landingState
	
	return null
