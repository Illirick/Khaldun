extends "res://scripts/Entity.gd"

signal died

export var min_distance_fly = 32 * .5
export var max_distance_fly = 32 * 3
export var min_flying_interval = 0.2
export var max_flying_interval = 5
export var bound_area_topleft = Vector2(16 * 32, -10 * 32)
export var bound_area_bottomright = Vector2(26 * 32, -6 * 32)

var destination
var waiting = false

func _ready():
	destination = position
	$AnimatedSprite.play("default")


func _process(delta):
	if destination != position:
		position = position.move_toward(destination, delta * speed)
	elif not waiting:
		$FlyingTimer.start(rand_range(min_flying_interval, max_flying_interval))
		waiting = true


func _on_FlyingTimer_timeout():
	var move_vector = Vector2.UP
	var distance = rand_range(min_distance_fly, max_distance_fly)
	
	move_vector = move_vector.rotated(randf() * TAU)
	move_vector *= distance
	
	destination = position + move_vector
	
	destination.x = clamp(destination.x, bound_area_topleft.x, bound_area_bottomright.x)
	destination.y = clamp(destination.y, bound_area_topleft.y, bound_area_bottomright.y)
	
	facing_direction = sign(destination.x - position.x)
	
	waiting = false

func die():
	.die()
	emit_signal("died")
	queue_free()
