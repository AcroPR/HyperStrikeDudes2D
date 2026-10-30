@tool
class_name HitboxAnimatorTool
extends EditorScript

var window = Window

var hitboxAnimator = preload("uid://dsvwuivoeji62")

func _run() -> void:
	window = Window.new()
	EditorInterface.popup_dialog(window, Rect2(Vector2(100,100), Vector2(1280,720)))
	
	window.close_requested.connect(func():
		window.queue_free()
		)
	
	var hitboxAnimatorInstant = hitboxAnimator.instantiate()
	window.add_child(hitboxAnimatorInstant)
