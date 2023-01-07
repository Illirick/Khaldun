extends Area2D

export var damage = 1
var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.y += gravity * delta
	position += velocity

func _on_Brick_body_entered(body):
	if body.name == "Player":
		print("p")
	if velocity.y > 1:
		queue_free()
