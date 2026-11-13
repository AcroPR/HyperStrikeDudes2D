class_name FighterExplosion
extends Node2D

@onready var circle: CPUParticles2D = $Circle
@onready var poly: CPUParticles2D = $Poly
@onready var stars: CPUParticles2D = $Stars
@onready var square: CPUParticles2D = $Square
@onready var circle2: CPUParticles2D = $Circle2
@onready var poly2: CPUParticles2D = $Poly2
@onready var stars2: CPUParticles2D = $Stars2
@onready var square2: CPUParticles2D = $Square2

var lastPosition: Vector2

func _set_particles(particles: CPUParticles2D):
	particles.one_shot = true
	particles.emitting = true

func _set_explosion_direction() -> void:
	_set_particles(circle)
	_set_particles(poly)
	_set_particles(stars)
	_set_particles(square)
	_set_particles(circle2)
	_set_particles(poly2)
	_set_particles(stars2)
	_set_particles(square2)
	var direction = lastPosition - global_position
	var angle = direction.angle()

	rotation = round(angle / (PI / 2.0)) * (PI / 2.0)


func _on_finished() -> void:
	queue_free()
