extends State

@export_category("States")
@export var airState: State
@export var idleState: State

@export_category("Attack Properties")
@export var animationName: String = "AttackN"

# Array of attack hitboxes
var attackHitboxes

func enter() -> void:
	super()
	parent.animationPlayer.play(animationName)
	attackHitboxes = HitboxImporter._load_csv(parent.fighterFolderName, animationName)
	parent._add_stale_move(animationName)

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
		if currentFrame == currentHitbox[0]:
			_create_hitbox(currentHitbox)

func process_frame(_delta: float) -> State:
	_check_for_hitboxes()
	if !parent.animationPlayer.is_playing():
		return idleState
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent._get_velocity(parent.weight) * delta
	
	var groundFriction = parent._get_velocity(parent.groundFriction)
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, groundFriction)
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return airState
	
	return null
