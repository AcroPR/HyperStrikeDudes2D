extends State

@export_category("States")
@export var airState: State
@export var idleState: State

@export_category("Dash Attack Properties")
@export var initialSpeed: int = 200
@export var friction: float = 0.25

var animationName: String = "DashAttack"

# Array of attack hitboxes
var attackHitboxes

var previousFrame: int

func enter() -> void:
	super()
	previousFrame = -1
	frames = 0
	parent.animationPlayer.play(animationName)
	match parent.facingRight:
		true:
			parent.velocity.x += initialSpeed
		false:
			parent.velocity.x -= initialSpeed

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
	frames += 1
	if frames < 10:
		if inputComponent._just_pressed("heavy"):
			return parent._return_heavy_state()
		var attack_state = parent._return_attack_state_stick()
		if attack_state != null: return attack_state
	if !parent.animationPlayer.is_playing():
		return idleState
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var groundFriction = parent._get_velocity(friction)
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, groundFriction)
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return airState
	
	return null
