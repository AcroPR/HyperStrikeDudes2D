@tool
extends VBoxContainer

@export var hitboxAnimator: HitboxAnimator

@onready var damage: LineEdit = $Damage/LineEdit
@onready var framesActive: LineEdit = $FramesActive/LineEdit
@onready var hitboxPriority: LineEdit = $HitboxPriority/LineEdit
@onready var hitboxStart: LineEdit = $HitboxStart/LineEdit

var hitboxNode: Hitbox
var startFrameIndex: int

func _set_values(_hitboxNode: Hitbox, _startFrameIndex):
	hitboxNode = _hitboxNode
	startFrameIndex = _startFrameIndex
	damage.text = str(int(hitboxNode.damage))
	framesActive.text = str(int(hitboxNode.framesActive))
	hitboxPriority.text = str(int(hitboxNode.priority))
	hitboxStart.text = str(hitboxAnimator.hitboxStartFrames[startFrameIndex]+1)

func _damage_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.damage = int(new_text)
	else:
		hitboxPriority.text = str(int(hitboxNode.damage))

func _frames_active_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.framesActive = int(new_text)
	else:
		hitboxPriority.text = str(int(hitboxNode.framesActive))

func _hitbox_priority_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxNode.priority = int(new_text)
	else:
		hitboxPriority.text = str(int(hitboxNode.priority))

func _hitbox_start_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		hitboxAnimator.hitboxStartFrames[startFrameIndex] = int(new_text)
	else:
		hitboxStart.text = str(int(hitboxAnimator.hitboxStartFrames[startFrameIndex]))
