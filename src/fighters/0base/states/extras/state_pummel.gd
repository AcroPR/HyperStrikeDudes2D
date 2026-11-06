extends State

@export_category("States")
@export var throwFState: State
@export var throwBState: State

var animationName: String = "Pummel"

# Array of attack hitboxes
var attackHitboxes

func enter() -> void:
	super()
	parent.animationPlayer.play(animationName)
	attackHitboxes = HitboxImporter._load_csv(parent.fighterFolderName, animationName)

func _create_hitbox(current_hitbox):
	var new_hitbox = Hitbox.new()._build_from_array(current_hitbox,false,0)
	new_hitbox.reversed = parent.model.scale.x < 0
	new_hitbox.parent = parent
	new_hitbox.attackName = animationName
	parent.hitboxManager.add_child(new_hitbox)

func _check_for_hitboxes():
	var currentFrame = int(parent.animationPlayer.current_animation_position * 60)
	for currentHitbox in attackHitboxes:
		if currentFrame == currentHitbox[0]:
			_create_hitbox(currentHitbox)

func _throw_state() -> State:
	var xDir = inputComponent._get_strength("move_right") - inputComponent._get_strength("move_left")
	if (xDir < 0 and parent.facingRight) or (xDir > 0 and !parent.facingRight):
		return throwBState
	return throwFState

func process_frame(_delta: float) -> State:
	_check_for_hitboxes()
	if !parent.animationPlayer.is_playing():
		return _throw_state()
	return null
